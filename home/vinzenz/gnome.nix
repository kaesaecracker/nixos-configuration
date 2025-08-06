{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs.gnomeExtensions; [
      gsconnect
      # battery-health-charging
      quick-settings-tweaker
      solaar-extension
      alphabetical-app-grid
    ] ++ (with pkgs; [foliate]);

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
