{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.my.gnome;
in {
  options.my.gnome = {
    enable = lib.mkEnableOption "gnome desktop";
  };

  config = lib.mkIf cfg.enable {
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

    environment.systemPackages = [pkgs.gnomeExtensions.gsconnect];

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
      vinzenz = lib.mkIf config.my.users.vinzenz.enable {
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
    };
  };
}
