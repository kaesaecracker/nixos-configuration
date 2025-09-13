{ pkgs, ... }:
{
  config = {
    # remove some gnome default apps
    environment.gnome.excludePackages = with pkgs; [
      cheese # photo booth
      epiphany # web browser
      evince # document viewer
      geary # email client
      gnome-maps
      gnome-weather
      gnome-tour
      sysprof
      orca # screen reader
      gnome-weather
      gnome-backgrounds
      gnome-user-docs
      yelp # help app
      # gnome-music
      # totem # video player
      # snapshot # camera
      # baobab # disk usage
    ];

    # RDP connections
    services.gnome.gnome-remote-desktop.enable = true;
    networking.firewall.allowedTCPPorts = [ 3389 ];

    home-manager.sharedModules = [
      {
        home.packages =
          with pkgs;
          [
            gitg
            meld
            simple-scan
            pinta
            dconf-editor
            gpaste
            ghex
            impression
            papers

            # graphical installer for flatpak apps
            gnome-software
          ]
          ++ (with gnomeExtensions; [
            caffeine
            appindicator
          ]);

        dconf.settings = import ./gnome-shared-dconf.nix;
      }

      {
        home.packages = with pkgs; [ trayscale ] ++ (with gnomeExtensions; [ tailscale-qs ]);
        dconf.settings."org/gnome/shell".enabled-extensions = [ "tailscale@joaophi.github.com" ];
      }
    ];
  };
}
