{
  config,
  pkgs,
  lib,
  ...
}: let
  isEnabled = config.my.desktop.enablePrinting;
in {
  options.my.desktop.enablePrinting = lib.mkEnableOption "printing";

  config = lib.mkIf isEnabled {
    services = {
      # Enable CUPS to print documents.
      printing.enable = true;
      
      avahi = {
        enable = true; # runs the Avahi daemon
        nssmdns4 = true; # enables the mDNS NSS plug-in
        openFirewall = true; # opens the firewall for UDP port 5353
      };
    };
  };
}
