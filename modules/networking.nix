_: {
  config = {
    services.tailscale = {
      enable = true;
      openFirewall = true;
    };

    networking.firewall = {
      enable = true;
      checkReversePath = "loose";
    };
  };
}
