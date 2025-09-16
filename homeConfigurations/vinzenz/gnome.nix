{ pkgs, lib, ... }:
{
  config = {
    home.packages = with pkgs; [
      gitg
      meld
      simple-scan
      pinta
      dconf-editor
      impression # usb image writer
      papers # pdf viewer
      gnome-software # for flatpak apps
      gnomeExtensions.solaar-extension
      snapshot
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
      "org/gnome/desktop/session".idle-delay = lib.hm.gvariant.mkUint32 300;
      "org/gnome/Connections".first-run = false;
    };
  };
}
