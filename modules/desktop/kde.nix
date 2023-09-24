{
  config,
  pkgs,
  lib,
  ...
}: let
  isEnabled = config.my.desktop.enableKde;
in {
  options.my.desktop.enableKde = lib.mkEnableOption "KDE desktop";

  config = lib.mkIf isEnabled {
    my.desktop.enable = true;

    # flatpak xdg-portal-kde crashes, otherwise this would be global
    services.flatpak.enable = false;

    services = {
      # Enable the KDE Plasma Desktop Environment.
      xserver = {
        desktopManager.plasma5.enable = true;

        displayManager = {
          sddm.enable = true;
          defaultSession = "plasmawayland";
        };
      };
    };

    environment = {
      systemPackages = with pkgs; [
        libsForQt5.kate
        libsForQt5.kalk
      ];

      plasma5.excludePackages = with pkgs.libsForQt5; [
        elisa
        gwenview
        okular
        khelpcenter
      ];
    };

    programs = {
      dconf.enable = true;
      partition-manager.enable = true;
    };
  };
}
