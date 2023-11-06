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
        enablePrinting = true;
      };
    };
  };
}
