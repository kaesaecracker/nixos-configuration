{...}: {
  imports = [
    (import ./modules {
      hostName = "vinzenz-pc2";
      enableHomeManager = true;
    })
  ];

  config = {
    my = {
      enabledUsers = ["vinzenz" "ronja"];
      desktop = {
        enableGnome = true;
        enableGaming = true;
        enablePrinting = true;
      };
    };

    users.users.vinzenz.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrY6tcgnoC/xbgL7vxSjddEY9MBxRXe9n2cAHt88/TT home roaming"
    ];
  };
}
