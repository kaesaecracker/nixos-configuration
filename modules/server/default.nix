{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.my.server;
in {
  imports = [];

  options.my.server = {
    enable = lib.mkEnableOption "server role";
  };

  config = lib.mkIf cfg.enable {
    services = {
      services.openssh.enable = true;
    };

    programs = {
    };

    networking.firewall = {
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
