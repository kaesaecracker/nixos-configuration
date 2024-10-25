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
  }: {
    nixosConfigurations = {
      vinzenz-lpt2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          ./common
          ./hosts/vinzenz-lpt2
        ];
      };
    };
  };
}
