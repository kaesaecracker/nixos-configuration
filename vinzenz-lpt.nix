{...}: {
  imports = [
    ./modules/desktop
    (import ./modules/hardware "vinzenz-lpt")
  ];

  config = {
    my = {
      desktop = {
        enable = true;
        gnome.enable = true;
        vinzenz.enable = true;
      };
    };

    # flatpak xdg-portal-kde crashes, otherwise this would be global
    services.flatpak.enable = true;
  };
}
