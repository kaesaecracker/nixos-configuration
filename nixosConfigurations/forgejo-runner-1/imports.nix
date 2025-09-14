{ nixosModules, ... }:
{
  imports = [
    nixosModules.podman
    ./forgejo-runner.nix
  ];
}
