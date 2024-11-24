{
  nixpkgs,
  nix-on-droid,
  home-manager,
  ...
}:
nix-on-droid.lib.nixOnDroidConfiguration {
  pkgs = import nixpkgs { system = "aarch64-linux"; };
  modules = [
    home-manager.nixosModules.home-manager
    ./sshd.nix
    ./stuff.nix
  ];
}
