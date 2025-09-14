{ vinzenzNixosModules, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware.nix

    ../../modules/gnome.nix
    ../../modules/gaming.nix
    vinzenzNixosModules.steam
    vinzenzNixosModules.printing
    vinzenzNixosModules.podman
    ../../modules/desktop-environment.nix
    ../../modules/desktop-hardware.nix

    ../../home/vinzenz
    ../../home/ronja
  ];
}
