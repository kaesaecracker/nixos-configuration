{
  lib,
  pkgs,
  osConfig,
  config,
  ...
}:
{
  options.vinzenz.gnome-extensions =
    let
      mkDefaultEnabledOption =
        name:
        lib.mkOption {
          default = true;
          example = false;
          description = "Whether to enable ${name}.";
          type = lib.types.bool;
        };
    in
    {
      enable = mkDefaultEnabledOption "gnome extended options";
      appindicator.enable = mkDefaultEnabledOption "appindicator";
      caffeine.enable = mkDefaultEnabledOption "caffeine";
      tailscale-qs.enable = lib.mkOption {
        default = osConfig.services.tailscale.enable;
        example = true;
        description = "Whether to enable tailscale quick setting.";
        type = lib.types.bool;
      };
      alphabetic-apps.enable = mkDefaultEnabledOption "alphabetic app grid";
      clock-show-seconds = mkDefaultEnabledOption "clock seconds";
      show-battery-percentage = mkDefaultEnabledOption "battery percentage";
      enable-numlock = mkDefaultEnabledOption "num lock on login";
      enable-systool-warning = lib.mkEnableOption "system configuration tool warning";
      edge-tiling = mkDefaultEnabledOption "edge tiling";
      dynamic-workspaces = mkDefaultEnabledOption "dynamic workspaces";
      tap-to-click = mkDefaultEnabledOption "tap to click";
      two-finger-scrolling = mkDefaultEnabledOption "two finger scrolling";
    };

  config =
    let
      cfg = config.vinzenz.gnome-extensions;
    in
    lib.mkIf cfg.enable (
      lib.mkMerge [
        {
          dconf = {
            enable = true;
            settings = {
              "org/gnome/shell" = {
                disable-user-extensions = false;
                disabled-extensions = [ ];
                enabled-extensions = [ ];
              };

              "ca/desrt/dconf-editor".show-warning = cfg.enable-systool-warning;
              "org/gnome/tweaks".show-extensions-notice = cfg.enable-systool-warning;
              "org/gnome/mutter" = {
                inherit (cfg) edge-tiling dynamic-workspaces;
              };
              "org/gnome/desktop/peripherals/touchpad" = {
                inherit (cfg) tap-to-click;
                two-finger-scrolling-enabled = cfg.two-finger-scrolling;
              };
              "org/gnome/desktop/interface" = {
                inherit (cfg) clock-show-seconds show-battery-percentage;
              };
            };
          };
        }

        (lib.mkIf cfg.tailscale-qs.enable {
          home.packages = [ pkgs.gnomeExtensions.tailscale-qs ];
          dconf.settings."org/gnome/shell".enabled-extensions = [ "tailscale@joaophi.github.com" ];
        })

        (lib.mkIf cfg.appindicator.enable {
          home.packages = [ pkgs.gnomeExtensions.appindicator ];
          dconf.settings."org/gnome/shell".enabled-extensions = [ "appindicatorsupport@rgcjonas.gmail.com" ];
        })

        (lib.mkIf cfg.caffeine.enable {
          home.packages = [ pkgs.gnomeExtensions.caffeine ];
          dconf.settings."org/gnome/shell".enabled-extensions = [ "caffeine@patapon.info" ];
        })

        (lib.mkIf cfg.alphabetic-apps.enable {
          home.packages = [ pkgs.gnomeExtensions.alphabetical-app-grid ];
          dconf.settings = {
            "org/gnome/shell".enabled-extensions = [ "AlphabeticalAppGrid@stuarthayhurst" ];
            "org/gnome/shell/extensions/alphabetical-app-grid".folder-order-position = "start";
          };
        })

        (lib.mkIf cfg.enable-numlock {
          dconf.settings."org/gnome/desktop/peripherals/keyboard".numlock-state = true;
        })
      ]
    );
}
