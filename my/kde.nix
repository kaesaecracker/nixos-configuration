{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.kde;
in {
  options.my.kde = {
    enable = lib.mkEnableOption "KDE desktop";
  };

  config = lib.mkIf cfg.enable {
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

    environment.systemPackages = with pkgs; [
      libsForQt5.kate
      libsForQt5.kalk
    ];

    environment.plasma5.excludePackages = with pkgs.libsForQt5; [
      elisa
      gwenview
      okular
      khelpcenter
    ];

    programs = {
      dconf.enable = true;
      partition-manager.enable = true;
    };

    home-manager.users.vinzenz = {
      config,
      pkgs,
      ...
    }: {
      home = {
        packages = with pkgs; [
        ];
      };

      services.kdeconnect = {
        enable = true;
        indicator = true;
      };
    };
  };
}
