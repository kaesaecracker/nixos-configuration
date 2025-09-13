{
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.checkReversePath = "loose";
}
