{ lib, config, ... }:
{
  options.my.openssh.enable = lib.mkEnableOption "OpenSSH server";

  config = lib.mkIf config.my.openssh.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };
}
