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

    services.flatpak.enable = true;
  };
}
