{
  lib,
  config,
  pkgs,
  ...
}: {
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

        dconf.settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            clock-show-seconds = true;
            show-battery-percentage = true;
          };
          "org/gnome/mutter" = {
            edge-tiling = true;
            dynamic-workspaces = true;
          };
          "org/gnome/desktop/peripherals/keyboard" = {
            numlock-state = true;
          };
          "org/gnome/desktop/peripherals/touchpad" = {
            tap-to-click = true;
            two-finger-scrolling-enabled = true;
          };
          "org/gnome/tweaks" = {
            show-extensions-notice = false;
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
              "solaar-extension@sidevesh"
            ];
          };
          "ca/desrt/dconf-editor" = {
            show-warning = false;
          };
          "org/gnome/desktop/wm/keybindings" = {
            switch-windows = ["<Alt>Tab"];
            switch-windows-backward = ["<Shift><Alt>Tab"];
            switch-applications = ["<Super>Tab"];
            switch-applications-backward = ["<Shift><Super>Tab"];
          };
        };

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
