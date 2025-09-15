{ vinzenzNixosModules, vinzenzHomeConfigurations, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware.nix
    ./vscode-server.nix
    ./hass.nix

    vinzenzNixosModules.gnome
    vinzenzNixosModules.wine-gaming
    vinzenzNixosModules.steam
    vinzenzNixosModules.printing
    vinzenzNixosModules.podman
    vinzenzNixosModules.vinzenz-desktop-settings

    vinzenzHomeConfigurations.vinzenz
    vinzenzHomeConfigurations.ronja
  ];
}
