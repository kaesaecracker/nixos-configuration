{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs.gnomeExtensions; [
      solaar-extension
    ];

    dconf.settings = {
      "org/gnome/shell".enabled-extensions = [
        "GPaste@gnome-shell-extensions.gnome.org"
        "solaar-extension@sidevesh"
      ];
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/gnome/desktop/wm/keybindings" = {
        switch-windows = [ "<Alt>Tab" ];
        switch-windows-backward = [ "<Shift><Alt>Tab" ];
        switch-applications = [ "<Super>Tab" ];
        switch-applications-backward = [ "<Shift><Super>Tab" ];
      };
    };
  };
}
