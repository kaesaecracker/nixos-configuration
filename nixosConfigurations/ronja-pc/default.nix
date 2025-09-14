{ vinzenzNixosModules, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware.nix

    ../../modules/gnome.nix
    ../../modules/gaming.nix
    vinzenzNixosModules.steam
    ../../modules/desktop-environment.nix
    ../../modules/desktop-hardware.nix

    ../../home/ronja
  ];
}
