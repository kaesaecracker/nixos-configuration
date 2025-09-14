{ nixosModules, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware.nix

    ../../modules/gnome.nix
    ../../modules/gaming.nix
    nixosModules.steam
    ../../modules/desktop-environment.nix
    ../../modules/desktop-hardware.nix

    ../../home/ronja
  ];
}
