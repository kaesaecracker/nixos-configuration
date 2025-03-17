{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      lix-module,
      niri,
    }:
    let
      devices = {
        vinzenz-lpt2 = "x86_64-linux";
        vinzenz-pc2 = "x86_64-linux";
        hetzner-vpn2 = "aarch64-linux";
        forgejo-runner-1 = "aarch64-linux";
      };
      homeDevices = [
        "vinzenz-lpt2"
        "vinzenz-pc2"
      ];
      forDevice = f: nixpkgs.lib.mapAttrs f devices;
    in
    {
      nixosConfigurations = forDevice (
        device: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules =
            [
              lix-module.nixosModules.default

              { networking.hostName = device; }

              ./modules/globalinstalls.nix
              ./modules/networking.nix
              ./modules/nixpkgs.nix

              ./hosts/${device}/hardware.nix
              ./hosts/${device}/imports.nix
              ./hosts/${device}/configuration.nix
            ]
            ++ (nixpkgs.lib.optionals (builtins.elem device homeDevices) [
              home-manager.nixosModules.home-manager
              { home-manager.extraSpecialArgs = { inherit device; }; }
              ./modules/home-manager.nix

              ./modules/i18n.nix

              niri.nixosModules.niri
              { nixpkgs.overlays = [ niri.overlays.niri ]; }
            ]);
        }
      );

      formatter = {
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
        aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixfmt-rfc-style;
      };
    };
}
