{
  config,
  lib,
  devices,
  ...
}:
let
  sshKeyPath = "/etc/nix/distributed-build-key";
  buildUser = "remotebuild";

  # Collect all per-device public keys that have been registered.
  authorizedPublicKeys = lib.pipe devices [
    (lib.filterAttrs (_: v: (v.distributedBuilds or { }) ? clientPublicKey))
    (lib.mapAttrsToList (_: v: v.distributedBuilds.clientPublicKey))
  ];

  buildServerDevices = lib.filterAttrs (
    _: v: (v.distributedBuilds or { }).isBuilder or false
  ) devices;

  knownHosts = lib.pipe buildServerDevices [
    (lib.filterAttrs (_: v: v.distributedBuilds ? hostPublicKey))
    (lib.mapAttrs (
      _: v: {
        publicKey = v.distributedBuilds.hostPublicKey;
      }
    ))
  ];

  buildMachineList = lib.mapAttrsToList (
    hostName: v:
    {
      inherit hostName;
      systems = [ v.system ];
      sshUser = buildUser;
      sshKey = sshKeyPath;
      protocol = "ssh-ng";
    }
    // lib.optionalAttrs (v.distributedBuilds ? speedFactor) {
      speedFactor = v.distributedBuilds.speedFactor;
    }
    // {
      supportedFeatures = [
        "nixos-test"
        "big-parallel"
        "kvm"
        "benchmark"
      ];
    }
  ) buildServerDevices;

  remoteMachines = builtins.filter (m: m.hostName != config.networking.hostName) buildMachineList;
in
{
  options.my.distributedBuilds.enable = lib.mkEnableOption "distributed Nix builds";

  config = lib.mkIf config.my.distributedBuilds.enable {
    programs.ssh.knownHosts = knownHosts;

    # Dedicated user for receiving distributed build connections
    users.users.${buildUser} = {
      isSystemUser = true;
      group = buildUser;
      useDefaultShell = true;
      openssh.authorizedKeys.keys = map (
        k: ''command="nix daemon --stdio",restrict ${k}''
      ) authorizedPublicKeys;
    };
    users.groups.${buildUser} = { };

    nix = {
      distributedBuilds = remoteMachines != [ ];
      buildMachines = remoteMachines;
      settings = {
        trusted-users = [ buildUser ];
        builders-use-substitutes = true;
        # Use build machines as binary caches so already-built paths are downloaded
        # rather than rebuilt. Only machines with a storeSigningPublicKey are used.
        substituters = lib.pipe buildServerDevices [
          (lib.filterAttrs (_: v: v.distributedBuilds ? storeSigningPublicKey))
          (lib.mapAttrsToList (hostName: _: "ssh-ng://${buildUser}@${hostName}"))
          (lib.filter (s: s != "ssh-ng://${buildUser}@${config.networking.hostName}"))
        ];
        trusted-public-keys = lib.pipe buildServerDevices [
          (lib.mapAttrsToList (_: v: v.distributedBuilds.storeSigningPublicKey or null))
          (builtins.filter (k: k != null))
        ];
        secret-key-files =
          let
            thisDevice = devices.${config.networking.hostName} or { };
          in
          lib.optional (thisDevice.distributedBuilds.isBuilder or false) "/etc/nix/signing-key.sec";
        max-jobs = (devices.${config.networking.hostName}.distributedBuilds or { }).maxJobs or "auto";
        cores = 0;
        min-free = 10 * 1024 * 1024;
        max-free = 200 * 1024 * 1024;
      };
    };

    systemd.services.nix-daemon.serviceConfig = {
      MemoryAccounting = true;
      MemoryMax = "90%";
      OOMScoreAdjust = 500;
    };
  };
}
