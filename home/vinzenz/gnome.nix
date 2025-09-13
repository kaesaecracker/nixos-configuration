{ pkgs, ... }:
{
  config = {
    home.packages =
      with pkgs.gnomeExtensions;
      [
        # battery-health-charging
        quick-settings-tweaker
        solaar-extension
        alphabetical-app-grid
      ]
      ++ (with pkgs; [ foliate ]);

    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          "GPaste@gnome-shell-extensions.gnome.org"
          "solaar-extension@sidevesh"
          "AlphabeticalAppGrid@stuarthayhurst"
        ];
      };
    };
  };
}
