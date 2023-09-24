{pkgs, ...}: {
  imports = [
    (import ./modules {
      hostName = "vinzenz-pc2";
      enableHomeManager = true;
    })
  ];

  config = {
    my.desktop = {
      enableKde = true;
      enableGaming = true;

      vinzenz.enable = true;
      ronja.enable = true;
    };

    users.groups."games" = {
      members = ["vinzenz" "ronja"];
    };

    users.users.vinzenz.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrY6tcgnoC/xbgL7vxSjddEY9MBxRXe9n2cAHt88/TT home roaming"
    ];
  };
}
