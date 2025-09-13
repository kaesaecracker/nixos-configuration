{ pkgs, ... }:
{
  services = {
    xserver = {
      # Enable the GNOME Desktop Environment.
      desktopManager.gnome = {
        enable = true;
        extraGSettingsOverridePackages = [ pkgs.mutter ];
        extraGSettingsOverrides = ''
          [org.gnome.mutter]
          experimental-features=['scale-monitor-framebuffer']
        '';
      };
      displayManager.gdm.enable = true;
      excludePackages = [ pkgs.xterm ];
    };

    displayManager.defaultSession = "gnome";

    gnome = {
      tinysparql.enable = false;
      localsearch.enable = false;
      sushi.enable = true;
    };
  };

  programs = {
    dconf.enable = true;
    gpaste.enable = true;
  };
}
