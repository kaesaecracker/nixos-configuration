{ nixosModules, ... }:
{
  imports = [
    ../../modules/gnome.nix
    ../../modules/gaming.nix
    nixosModules.printing
    ../../modules/podman.nix
    #../../modules/niri.nix
    ../../modules/desktop-environment.nix
    ../../modules/desktop-hardware.nix

    ../../home/vinzenz
    ../../home/ronja
  ];
}
