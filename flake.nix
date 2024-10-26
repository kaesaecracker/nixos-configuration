{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    lix-module,
    ...
  }: let
    common-modules = [
      lix-module.nixosModules.default
      ./common
    ];
  in {
    nixosConfigurations = {
      vinzenz-lpt2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          common-modules
          ++ [
            home-manager.nixosModules.home-manager
            ./hosts/vinzenz-lpt2
          ];
      };
      vinzenz-pc2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          common-modules
          ++ [
            home-manager.nixosModules.home-manager
            ./hosts/vinzenz-pc2
          ];
      };
      hetzner-vpn1 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules =
          common-modules
          ++ [
            ./hosts/hetzner-vpn1

            {
              # uncomment for build check on non arm system (requires --impure)
              # nixpkgs.buildPlatform = builtins.currentSystem;
            }
          ];
      };
    };
  };
}
