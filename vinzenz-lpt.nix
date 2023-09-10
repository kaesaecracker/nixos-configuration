{...}: {
  imports = [
    ./modules
    (import ./hardware "vinzenz-lpt")
  ];

  config = {
    my = {
      gnome.enable = true;
      home.vinzenz.enable = true;
    };

    services.flatpak.enable = true;
  };
}
