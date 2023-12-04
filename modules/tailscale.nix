{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.my.tailscale;
in {
  options.my.tailscale = {
    enable = lib.mkEnableOption "enable tailscale vpn";
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;
    };
  };
}
