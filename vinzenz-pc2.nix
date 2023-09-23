{pkgs, ...}: {
  imports = [
    ./modules/desktop
    (import ./modules/hardware "vinzenz-pc2")
  ];

  config = {
    my.desktop = {
      enable = true;
      kde.enable = true;
      vinzenz.enable = true;
      ronja.enable = true;
      gaming.enable = true;
    };

    environment.systemPackages = [pkgs.radeontop];

    users.groups."games" = {
      members = ["vinzenz" "ronja"];
    };

    users.users.vinzenz.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrY6tcgnoC/xbgL7vxSjddEY9MBxRXe9n2cAHt88/TT home roaming"
    ];
  };
}
