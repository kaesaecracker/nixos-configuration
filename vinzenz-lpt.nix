{...}: {
  networking.hostName = "vinzenz-lpt";

  imports = [
    ./common.nix
    ./vinzenz-lpt-hardware-configuration.nix
  ];
}
