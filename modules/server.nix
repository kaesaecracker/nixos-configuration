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
    networking.firewall = {
      enable = true;
      allowedTCPPortRanges = [
        # {
        #   # ssh
        #   from = 22;
        #   to = 22;
        # }
      ];
    };
  };
}
