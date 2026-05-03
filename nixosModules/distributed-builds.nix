{
  config,
  lib,
  allDevices,
  thisDevice,
  ...
}:
let
  clientSshKeyPath = "/etc/nix/distributed-build-key";
  buildUser = "remotebuild";

  # Collect all per-device public keys that have been registered.
  allClientPublicKeys = lib.pipe allDevices [
    (lib.filterAttrs (_: v: (v.distributedBuilds or { }) ? clientPublicKey))
    (lib.mapAttrsToList (_: v: v.distributedBuilds.clientPublicKey))
  ];

  isClient = (thisDevice.distributedBuilds or { }) ? clientPublicKey;

  buildServerDevices = lib.filterAttrs (
    _: v: (v.distributedBuilds or { }).isBuilder or false
  ) allDevices;

  sshHostname = m: m.publicFqdn or m.hostName;

  buildServerKnownHosts = lib.pipe buildServerDevices [
    (lib.filterAttrs (_: v: v.distributedBuilds ? hostPublicKey))
    (lib.mapAttrs (
      name: v: {
        publicKey = v.distributedBuilds.hostPublicKey;
        hostNames = [ (v.publicFqdn or name) ];
      }
    ))
  ];

  remoteBuildServerDevices = builtins.filter (m: m.hostName != config.networking.hostName) (
    lib.mapAttrsToList (name: v: v // { hostName = name; }) buildServerDevices
  );

  buildMachines = map (
    m:
    {
      hostName = sshHostname m;
      systems = [ m.system ];
      sshUser = buildUser;
      sshKey = clientSshKeyPath;
      protocol = "ssh-ng";
    }
    // lib.optionalAttrs (m.distributedBuilds ? speedFactor) {
      speedFactor = m.distributedBuilds.speedFactor;
    }
    // {
      supportedFeatures = [
        "nixos-test"
        "big-parallel"
        "kvm"
        "benchmark"
      ];
    }
  ) remoteBuildServerDevices;
in
{
  options.my.distributedBuilds.enable = lib.mkEnableOption "distributed Nix builds";

  config = lib.mkIf config.my.distributedBuilds.enable (
    lib.mkMerge [

      # All machines
      {
        assertions =
          lib.mapAttrsToList (name: v: {
            assertion = v.distributedBuilds ? hostPublicKey && v.distributedBuilds ? storeSigningPublicKey;
            message = "devices.${name}: isBuilder = true requires distributedBuilds.hostPublicKey and distributedBuilds.storeSigningPublicKey";
          }) buildServerDevices
          ++ lib.mapAttrsToList (name: v: {
            assertion = lib.hasPrefix "ssh-" v.distributedBuilds.clientPublicKey;
            message = "devices.${name}: distributedBuilds.clientPublicKey must start with 'ssh-'";
          }) (lib.filterAttrs (_: v: (v.distributedBuilds or { }) ? clientPublicKey) allDevices)
          ++ lib.mapAttrsToList (name: v: {
            assertion = builtins.match ".+:.+" v.distributedBuilds.storeSigningPublicKey != null;
            message = "devices.${name}: distributedBuilds.storeSigningPublicKey must be in '<name>:<base64>' format";
          }) (lib.filterAttrs (_: v: (v.distributedBuilds or { }) ? storeSigningPublicKey) allDevices);

        nix.settings = {
          #fallback = true;
          connect-timeout = 5;
          trusted-public-keys = lib.pipe buildServerDevices [
            (lib.mapAttrsToList (_: v: v.distributedBuilds.storeSigningPublicKey or null))
            (builtins.filter (k: k != null))
          ];
          max-jobs = (thisDevice.distributedBuilds or { }).maxJobs or "auto";
          cores = 0;
          min-free = 10 * 1024 * 1024;
          max-free = 200 * 1024 * 1024;
        };
        systemd.services.nix-daemon.serviceConfig = {
          MemoryAccounting = true;
          MemoryMax = "90%";
          OOMScoreAdjust = 500;
        };
      }

      # Server: accept incoming build connections
      (lib.mkIf (thisDevice.distributedBuilds.isBuilder or false) {
        users.users.${buildUser} = {
          isSystemUser = true;
          group = buildUser;
          useDefaultShell = true;
          openssh.authorizedKeys.keys = map (
            k: ''command="nix daemon --stdio",restrict ${k}''
          ) allClientPublicKeys;
        };
        users.groups.${buildUser} = { };
        nix.settings = {
          trusted-users = [ buildUser ];
          secret-key-files = [ "/etc/nix/signing-key.sec" ];
        };
      })

      # Client: connect to build servers for building and substitution
      (lib.mkIf isClient {
        programs.ssh = {
          knownHosts = buildServerKnownHosts;
          extraConfig = lib.concatStringsSep "\n" (
            lib.mapAttrsToList (
              name: v:
              let
                names = lib.unique [
                  name
                  (v.publicFqdn or name)
                ];
              in
              ''
                Match originalhost ${lib.concatStringsSep "," names} user ${buildUser}
                  IdentityFile ${clientSshKeyPath}
                  IdentitiesOnly yes
              ''
            ) buildServerDevices
          );
        };
        nix = {
          distributedBuilds = buildMachines != [ ];
          buildMachines = buildMachines;
          settings = {
            builders-use-substitutes = true;
            substituters = map (m: "ssh-ng://${buildUser}@${sshHostname m}") (
              builtins.filter (m: m.distributedBuilds ? storeSigningPublicKey) remoteBuildServerDevices
            );
          };
        };
      })

    ]
  );
}
