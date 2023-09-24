{
  config,
  pkgs,
  lib,
  ...
}: let
  desktopCfg = config.my.desktop;
  isEnabled = desktopCfg.enableGnome;

  applyGnomeUserSettings = {
    home.packages = with pkgs; [
      gnome.gpaste
      amberol
    ];
    dconf.settings = {
      "org/gnome/desktop/peripherals/keyboard" = {
        numlock-state = true;
      };
    };
  };
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

    environment.systemPackages = with pkgs; [
      gnomeExtensions.gsconnect
    ];

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

    home-manager.users = {
      vinzenz = lib.mkIf desktopCfg.vinzenz.enable applyGnomeUserSettings;
      ronja = lib.mkIf desktopCfg.ronja.enable applyGnomeUserSettings;
    };
  };
}
