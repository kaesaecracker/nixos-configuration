{...}: {
  imports = [
    (import ./modules {
      hostName = "vinzenz-lpt";
      enableHomeManager = true;
    })
  ];

  config = {
    my.desktop = {
      enableGnome = true;
      enableGaming = true;

      vinzenz.enable = true;
    };

    # flatpak xdg-portal-kde crashes, otherwise this would be global
    services.flatpak.enable = true;
  };
}
