{ nixosModules, ... }:
{
  imports = [
    ../../modules/gnome.nix
    ../../modules/gaming.nix
    nixosModules.steam
    ../../modules/desktop-environment.nix
    ../../modules/desktop-hardware.nix

    ../../home/ronja
  ];
}
