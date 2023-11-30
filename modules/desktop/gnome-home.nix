{
  lib,
  config,
  pkgs,
  ...
}: let
  isEnabled = config.my.desktop.enableGnome;
in {
  config = lib.mkIf isEnabled {
    home-manager.sharedModules = [
      {
        home.packages = with pkgs;
          [
            amberol
          ]
          ++ (with gnome; [
            dconf-editor
            gpaste
          ])
          ++ (with gnomeExtensions; [
            caffeine
            appindicator
            gsconnect
          ]);

        dconf.settings = {
          "org/gnome/desktop/peripherals/keyboard" = {
            numlock-state = true;
          };
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            clock-show-seconds = true;
          };
          "org/gnome/tweaks" = {
            show-extensions-notice = false;
          };
          "ca/desrt/dconf-editor" = {
            show-warning = false;
          };
          "org/gnome/shell" = {
            disable-user-extensions = false;
            disabled-extensions = [];
            enabled-extensions = [
              "appindicatorsupport@rgcjonas.gmail.com"
              "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
              "caffeine@patapon.info"
              "GPaste@gnome-shell-extensions.gnome.org"
              "gsconnect@andyholmes.github.io"
            ];
          };
        };

        gtk = {
          enable = true;
          iconTheme.name = "Adwaita";
          cursorTheme.name = "Adwaita";
          theme = {
            name = "adw-gtk3";
            package = pkgs.adw-gtk3;
          };
        };
      }
    ];
  };
}
