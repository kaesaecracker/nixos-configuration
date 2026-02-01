{ pkgs, ... }:
{
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
    libreoffice-qt6
  ];

  fonts.enableDefaultPackages = true;

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  # RDP connections
  services.gnome.gnome-remote-desktop.enable = true;
  networking.firewall.allowedTCPPorts = [ 3389 ];
}
