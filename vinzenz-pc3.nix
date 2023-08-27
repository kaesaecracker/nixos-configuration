{...}: {
  networking.hostName = "vinzenz-pc3";

  imports = [
    ./vinzenz-pc3-hardware-configuration.nix
    ./common.nix
    ./kde.nix
  ];
}
