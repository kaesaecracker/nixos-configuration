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

  # === Onboarding a device as a build client ===
  #
  # 1. Generate a key pair on the device:
  #      sudo ssh-keygen -t ed25519 -f /etc/nix/distributed-build-key -N "" -C "$(hostname)-nix-builds"
  #    (owned by root, mode 0600)
  #
  # 2. Add the public key to the device entry in flake.nix:
  #      distributedBuilds.clientPublicKey = "ssh-ed25519 AAAA... <hostname>-nix-builds";
  #
  # 3. Rebuild all machines so they pick up the new authorized key.
  #
  # === Marking a device as a build server ===
  #
  # Add to its entry in flake.nix:
  #   distributedBuilds.isBuilder = true;
  #   distributedBuilds.hostPublicKey = "ssh-ed25519 AAAA...";  # from: ssh-keyscan -t ed25519 <hostname>
  # All machines automatically discover and use it after the next rebuild.

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
