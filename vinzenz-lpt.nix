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
      tailscale.enable = true;
      desktop = {
        enableGnome = true;
        enableGaming = true;
        enablePrinting = true;
      };
    };
  };
}
