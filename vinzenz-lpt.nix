{...}: {
  imports = [
    (import ./modules {
      hostName = "vinzenz-lpt";
      enableDesktop = true;
    })
  ];

  config = {
    my.desktop = {
      gnome.enable = true;
      vinzenz.enable = true;
      gaming.enable = true;
    };

    # flatpak xdg-portal-kde crashes, otherwise this would be global
    services.flatpak.enable = true;
  };
}
