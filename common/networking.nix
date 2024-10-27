{ ... }:
{
  config = {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PermitRootLogin = "without-password";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

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
