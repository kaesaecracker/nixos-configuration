{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.my.muedeDesktopSettings.enable = lib.mkEnableOption "muede desktop settings (Firefox, Logitech, RDP)";

  config = lib.mkIf config.my.muedeDesktopSettings.enable {
    my.overlays.niri.enable = true;
    programs.niri.enable = true;

    programs.firefox.enable = true;

    environment.systemPackages = with pkgs; [
      lm_sensors
      libreoffice-qt6
      usbutils
    ];

    fonts.enableDefaultPackages = true;

    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };

    # RDP connections
    services.gnome.gnome-remote-desktop.enable = true;
    networking.firewall.allowedTCPPorts = [ 3389 ];
  };
}
