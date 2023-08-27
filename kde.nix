{
  config,
  pkgs,
  ...
}: {
  services = {
    # Enable the KDE Plasma Desktop Environment.
    xserver = {
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
    };
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
