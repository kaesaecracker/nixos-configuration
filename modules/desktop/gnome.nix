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
        displayManager = {
          gdm.enable = true;
          defaultSession = "gnome";
        };
        desktopManager.gnome.enable = true;
      };

      gnome = {
        tracker-miners.enable = false;
        tracker.enable = false;
        sushi.enable = true;
        gnome-remote-desktop.enable = true;
      };
    };

    programs = {
      dconf.enable = true;
      gpaste.enable = true;
      kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
    };

    # remove some gnome default apps
    environment.gnome.excludePackages = with pkgs.gnome; [
      cheese # photo booth
      epiphany # web browser
      evince # document viewer
      geary # email client
      #seahorse # password manager
      gnome-maps
      gnome-weather
      gnome-music
    ];

    # RDP connections
    networking.firewall.allowedTCPPorts = [3389];
  };
}
