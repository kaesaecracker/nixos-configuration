{ ... }:
{
  config = {
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
