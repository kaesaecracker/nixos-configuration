{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      lix-module,
      nixos-hardware,
    }:
    let
      devices = {
        vinzenz-lpt2 = "x86_64-linux";
        vinzenz-pc2 = "x86_64-linux";
        hetzner-vpn2 = "aarch64-linux";
        forgejo-runner-1 = "aarch64-linux";
      };
      forDevice = f: nixpkgs.lib.mapAttrs f devices;
    in
    {
      nixosConfigurations = forDevice (
        device: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            lix-module.nixosModules.default
            home-manager.nixosModules.home-manager

            { networking.hostName = device; }

            ./common

            ./hosts/${device}/hardware.nix
            ./hosts/${device}/imports.nix
            ./hosts/${device}/configuration.nix
          ];
        }
      );

      formatter = {
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
        aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixfmt-rfc-style;
      };
    };
}
