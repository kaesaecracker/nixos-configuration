inputs@{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs.gnomeExtensions; [
      gsconnect
      # battery-health-charging
      quick-settings-tweaker
      solaar-extension
      alphabetical-app-grid
    ];

    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          "GPaste@gnome-shell-extensions.gnome.org"
          "gsconnect@andyholmes.github.io"
          "solaar-extension@sidevesh"
          "AlphabeticalAppGrid@stuarthayhurst"
        ];
      };
    };
  };
}
