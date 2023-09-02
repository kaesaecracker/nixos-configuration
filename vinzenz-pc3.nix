{...}: {
  networking.hostName = "vinzenz-pc3";

  imports = [
    ./vinzenz-pc3-hardware-configuration.nix
    ./common.nix
    ./kde.nix
  ];

  users.users.vinzenz.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrY6tcgnoC/xbgL7vxSjddEY9MBxRXe9n2cAHt88/TT home roaming"
  ];
}
