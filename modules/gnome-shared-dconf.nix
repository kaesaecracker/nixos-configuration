{
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
    disabled-extensions = [ ];
    enabled-extensions = [
      "tailscale@joaophi.github.com"
      "appindicatorsupport@rgcjonas.gmail.com"
      "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
      "caffeine@patapon.info"
    ];
  };
  "ca/desrt/dconf-editor" = {
    show-warning = false;
  };
  "org/gnome/desktop/wm/keybindings" = {
    switch-windows = [ "<Alt>Tab" ];
    switch-windows-backward = [ "<Shift><Alt>Tab" ];
    switch-applications = [ "<Super>Tab" ];
    switch-applications-backward = [ "<Shift><Super>Tab" ];
  };
  "org/gnome/shell/extensions/alphabetical-app-grid" = {
    folder-order-position = "start";
  };
}
