{ vinzenzNixosModules, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware.nix

    vinzenzNixosModules.podman
    ./forgejo-runner.nix
  ];
}
