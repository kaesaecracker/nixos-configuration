{ nixosModules, ... }:
{
  imports = [
    ../../modules/gnome.nix
    ../../modules/gaming.nix
    nixosModules.steam
    nixosModules.printing
    nixosModules.podman
    ../../modules/desktop-environment.nix
    ../../modules/desktop-hardware.nix

    ../../home/vinzenz
    ../../home/ronja
  ];
}
