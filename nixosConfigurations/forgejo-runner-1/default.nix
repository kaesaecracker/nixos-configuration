{ nixosModules, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware.nix

    nixosModules.podman
    ./forgejo-runner.nix
  ];
}
