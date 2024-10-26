{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../modules/gnome.nix
  ];
  config = {
    home-manager.sharedModules = [
      {
        home.packages = with pkgs;
          [
            amberol
            gitg
            gnome-builder
            meld
            simple-scan
            pinta
          ]
          ++ (with gnome; [
            dconf-editor
            gpaste

            # graphical installer for flatpak apps
            gnome-software
          ])
          ++ (with gnomeExtensions; [
            caffeine
            appindicator
            gsconnect
            battery-health-charging
            quick-settings-tweaker
            solaar-extension
          ]);

        dconf.settings = import ./gnome-shared-dconf.nix;

        gtk = {
          enable = true;
          iconTheme.name = "Adwaita";
          cursorTheme.name = "Adwaita";
          theme = {
            name = "adw-gtk3-dark";
            package = pkgs.adw-gtk3;
          };
        };
      }

      {
        home.packages = with pkgs;
          [
            trayscale
          ]
          ++ (with gnomeExtensions; [
            tailscale-qs
          ]);
        dconf.settings."org/gnome/shell".enabled-extensions = ["tailscale@joaophi.github.com"];
      }
    ];
  };
}
