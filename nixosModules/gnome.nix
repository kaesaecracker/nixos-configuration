{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.vinzenz = {
    keep-gnome-default-apps = lib.mkEnableOption "keep gnome default apps";
  };

  config = lib.mkMerge [
    {
      services = {
        xserver.excludePackages = [ pkgs.xterm ];

        # Enable the GNOME Desktop Environment.
        displayManager.gdm.enable = true;
        desktopManager.gnome = {
          enable = true;
          extraGSettingsOverridePackages = [ pkgs.mutter ];
          extraGSettingsOverrides = ''
            [org.gnome.mutter]
            experimental-features=['scale-monitor-framebuffer']
          '';
        };

        gnome = {
          tinysparql.enable = false;
          localsearch.enable = false;
          sushi.enable = true;
        };
      };

      programs = {
        dconf.enable = true;
        gpaste.enable = true;
      };
    }
    (lib.mkIf (!config.vinzenz.keep-gnome-default-apps) {
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
        gnome-music
        totem # video player
        snapshot # camera
        baobab # disk usage
      ];
    })
  ];
}
