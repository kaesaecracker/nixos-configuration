{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.my.server;
in {
  options.my.server = {
    enable = lib.mkEnableOption "server role";
  };

  config = lib.mkIf cfg.enable {
    services = {
      # Enable the OpenSSH daemon.
      openssh = {
        enable = true;
        settings = {
          # PermitRootLogin = "no"; # this is managed through authorized keys
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };
    };

    networking.firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          # ssh
          from = 22;
          to = 22;
        }
      ];
    };
  };
}
