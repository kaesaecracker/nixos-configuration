{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.my.kde;

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
  options.my.kde = {
    enable = lib.mkEnableOption "KDE desktop";
  };

  config = lib.mkIf cfg.enable {
    my.desktop.enable = true;

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
      vinzenz = lib.mkIf config.my.home.vinzenz.enable applyKdeUserSettings;
      ronja = lib.mkIf config.my.home.ronja.enable applyKdeUserSettings;
    };
  };
}
