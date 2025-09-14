{ vinzenzNixosModules, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware.nix
    ./vscode-server.nix
    ./hass.nix

    ../../modules/gnome.nix
    ../../modules/gaming.nix
    vinzenzNixosModules.steam
    vinzenzNixosModules.printing
    vinzenzNixosModules.podman
    #../../modules/niri.nix
    ../../modules/desktop-environment.nix
    ../../modules/desktop-hardware.nix

    ../../home/vinzenz
    ../../home/ronja
  ];
}
