{...}: {
  networking.hostName = "vinzenz-lpt";

  imports = [
    ./vinzenz-lpt-hardware-configuration.nix
    ./common.nix
    ./gnome.nix
  ];
}
