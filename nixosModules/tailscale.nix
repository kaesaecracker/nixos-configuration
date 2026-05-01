{ lib, config, ... }:
{
  options.my.tailscale.enable = lib.mkEnableOption "Tailscale VPN";

  config = lib.mkIf config.my.tailscale.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;
    };

    networking.firewall.checkReversePath = "loose";
  };
}
