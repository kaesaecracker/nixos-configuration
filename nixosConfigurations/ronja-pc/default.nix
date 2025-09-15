{ vinzenzNixosModules, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware.nix

    vinzenzNixosModules.gnome
    vinzenzNixosModules.steam
    vinzenzNixosModules.wine-gaming
    vinzenzNixosModules.vinzenz-desktop-settings

    ../../home/ronja
  ];
}
