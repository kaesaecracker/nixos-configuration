{
  config,
  pkgs,
  lib,
  ...
}: let
  isEnabled = config.my.desktop.enableGnome;
in {
  options.my.desktop.enableGnome = lib.mkEnableOption "gnome desktop";

  config = lib.mkIf isEnabled {
    my.desktop.enable = true;

    services = {
      xserver = {
        # Enable the GNOME Desktop Environment.
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };

      gnome = {
        tracker-miners.enable = false;
        tracker.enable = false;
      };
    };

    programs = {
      gpaste.enable = true;
      kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
    };

    # remove some gnome default apps
    environment.gnome.excludePackages = with pkgs.gnome; [
      cheese # photo booth
      epiphany # web browser
      evince # document viewer
      geary # email client
      seahorse # password manager
      gnome-clocks
      gnome-maps
      gnome-weather
      gnome-music
      pkgs.gnome-connections
    ];
  };
}
