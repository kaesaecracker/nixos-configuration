{...}: {
  imports = [
    ./modules
    (import ./hardware "vinzenz-pc2")
  ];

  config = {
    my.kde.enable = true;
    my.home = {
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
