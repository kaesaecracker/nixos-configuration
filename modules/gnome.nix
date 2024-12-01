{ config, pkgs, ... }:
{
  config = {
    services = {
      xserver = {
        # Enable the GNOME Desktop Environment.
        desktopManager.gnome.enable = true;
        displayManager.gdm.enable = true;
        excludePackages = with pkgs; [ xterm ];
      };

      displayManager.defaultSession = "gnome";

      gnome = {
        tinysparql.enable = false;
        localsearch.enable = false;
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
    environment.gnome.excludePackages = with pkgs; [
      cheese # photo booth
      epiphany # web browser
      evince # document viewer
      geary # email client
      gnome-maps
      gnome-weather
      gnome-tour
      gnome-contacts
      sysprof
      orca # screen reader
      gnome-disk-utility
      gnome-system-monitor
      gnome-weather
      gnome-backgrounds
      gnome-user-docs
      gnome-calendar
      yelp # help app
      # gnome-music
      # totem # video player
      # snapshot # camera
      # baobab # disk usage
    ];

    environment.systemPackages = with pkgs; [
      ghex
      impression
    ];

    # RDP connections
    networking.firewall.allowedTCPPorts = [ 3389 ];
  };
}
