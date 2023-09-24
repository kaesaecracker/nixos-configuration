{...}: {
  imports = [
    (import ./modules {
      hostName = "vinzenz-lpt";
      enableHomeManager = true;
    })
  ];

  config = {
    my = {
      enabledUsers = ["vinzenz"];
      desktop = {
        enableGnome = true;
        enableGaming = true;
      };
    };

    # flatpak xdg-portal-kde crashes, otherwise this would be global
    services.flatpak.enable = true;
  };
}
