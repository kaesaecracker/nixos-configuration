{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.servicepoint-tanks;
  default-user-name = "servicepoint-tanks";
in
{
  options.services.servicepoint-tanks = {
    enable = lib.mkEnableOption "servicepoint-tanks";
    package = lib.mkPackageOption pkgs "servicepoint-tanks" { };
    urls = lib.mkOption {
      default = [ "http://localhost:5000" ];
      description = ''
        Configures which protocol to bind on which host:port combination.
      '';
      type = lib.types.listOf lib.types.str;
      example = [
        "http://0.0.0.0"
        "http://localhost:5000"
        # TODO: allow HTTPS
      ];
    };
    user = lib.mkOption {
      default = default-user-name;
      description = ''
        The user under which servicepoint-tanks is run.

        This module utilizes systemd's DynamicUser feature. See the corresponding section in
        {manpage}`systemd.exec(5)` for more details.
      '';
      type = lib.types.str;
    };
    group = lib.mkOption {
      default = default-user-name;
      description = ''
        The group under which servicepoint-tanks is run.

        This module utilizes systemd's DynamicUser feature. See the corresponding section in
        {manpage}`systemd.exec(5)` for more details.
      '';
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      users = lib.mkIf (cfg.user == default-user-name) {
        "${default-user-name}" = {
          isSystemUser = true;
          group = cfg.group;
        };
      };

      groups = lib.mkIf (cfg.group == default-user-name) {
        "${default-user-name}" = { };
      };
    };

    systemd.services.sericepoint-tanks = {
      description = "Run the servicepoint-tanks server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      environment = {
        ASPNETCORE_URLS = "${lib.strings.concatStringsSep ";" cfg.urls}";
      };

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        DynamicUser = true;

        Type = "exec";
        ExecStart = "${lib.getBin cfg.package}/bin/TanksServer";

        # hardening
        NoNewPrivileges = true;
        CapabilityBoundingSet = null;
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        SystemCallArchitectures = "native";
        AmbientCapabilities = "";
        PrivateMounts = true;
        PrivateUsers = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectClock = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ProtectControlGroups = "strict";
        LockPersonality = true;
        RemoveIPC = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictNamespaces = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"

          # TODO: enable unix domain socket bind
          # "AF_UNIX"
        ];

        # TODO: try fully AOT build with:
        #MemoryDenyWriteExecute = true;
      };
    };
  };
}
