{...}: {
  networking.hostName = "vinzenz-pc2";

  imports = [
    ./vinzenz-pc2-hardware-configuration.nix
    ./common.nix
    ./kde.nix
  ];
}
