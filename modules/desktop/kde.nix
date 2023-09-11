{
  config,
  pkgs,
  lib,
  ...
}: let
  desktopCfg = config.my.desktop;
  cfg = desktopCfg.kde;

  applyKdeUserSettings = {
    home = {
      packages = with pkgs; [
      ];
    };
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
in {
  config = lib.mkIf cfg.enable {
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

    home-manager.users = {
      vinzenz = lib.mkIf desktopCfg.vinzenz.enable applyKdeUserSettings;
      ronja = lib.mkIf desktopCfg.ronja.enable applyKdeUserSettings;
    };
  };
}
