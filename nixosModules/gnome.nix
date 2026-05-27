{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.my.gnome = {
    enable = lib.mkEnableOption "GNOME desktop environment";
    keep-default-apps = lib.mkEnableOption "keep gnome default apps";
  };

  config = lib.mkIf config.my.gnome.enable (
    lib.mkMerge [
      {
        # Workaround for GDM 50 + NixOS 26.05: greeter PAM session strips PATH so
        # gdm-wayland-session can't find `gnome-session` and exits 70.
        # https://github.com/NixOS/nixpkgs/issues/523332 — drop once #523948 lands.
        security.pam.services.gdm-launch-environment.rules.session.env-greeter = {
          control = "required";
          modulePath = "${config.security.pam.package}/lib/security/pam_env.so";
          settings.conffile = pkgs.writeText "gdm-launch-environment-env-conf" ''
            PATH          DEFAULT="''${PATH}:${pkgs.gnome-session}/bin"
            XDG_DATA_DIRS DEFAULT="''${XDG_DATA_DIRS}:/run/current-system/sw/share"
          '';
          settings.readenv = 0;
          order = 12200;
        };

        services = {
          xserver.excludePackages = [ pkgs.xterm ];

          # Enable the GNOME Desktop Environment.
          displayManager.gdm = {
            enable = true;
            debug = true;
          };
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
      (lib.mkIf (!config.my.gnome.keep-default-apps) {
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
    ]
  );
}
