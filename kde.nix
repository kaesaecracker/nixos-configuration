{
  config,
  pkgs,
  ...
}: {
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
}
