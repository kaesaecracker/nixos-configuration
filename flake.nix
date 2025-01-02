{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

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
    }:
    {
      nixosConfigurations =
        let
          host-params = {
            inherit nixpkgs;
            inherit home-manager;
            inherit lix-module;
            common-modules = [
              lix-module.nixosModules.default
              ./common
            ];
            desktop-modules = [
              home-manager.nixosModules.home-manager
              ./home
              ./modules/desktop-environment.nix
              ./modules/desktop-hardware.nix
            ];
          };
        in
        {
          vinzenz-lpt2 = import ./hosts/vinzenz-lpt2 host-params;
          vinzenz-pc2 = import ./hosts/vinzenz-pc2 host-params;
          hetzner-vpn2 = import ./hosts/hetzner-vpn2 host-params;
          ona-book = import ./hosts/ona-book host-params;
        };

      formatter = {
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
        aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixfmt-rfc-style;
      };
    };
}
