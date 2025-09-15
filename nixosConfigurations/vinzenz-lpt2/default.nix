{ vinzenzNixosModules, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware.nix

    vinzenzNixosModules.gnome
    vinzenzNixosModules.wine-gaming
    vinzenzNixosModules.steam
    vinzenzNixosModules.printing
    vinzenzNixosModules.podman
    vinzenzNixosModules.vinzenz-desktop-settings

    ../../home/vinzenz
    ../../home/ronja
  ];
}
