{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    zerforschen-plus = {
      url = "git+https://git.berlin.ccc.de/vinzenz/zerforschen.plus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      lix-module,
      niri,
      zerforschen-plus,
      nixpkgs-unstable,
    }:
    let
      devices = {
        vinzenz-lpt2 = "x86_64-linux";
        vinzenz-pc2 = "x86_64-linux";
        ronja-pc = "x86_64-linux";
        hetzner-vpn2 = "aarch64-linux";
        forgejo-runner-1 = "aarch64-linux";
      };
      homeDevices = [
        "vinzenz-lpt2"
        "vinzenz-pc2"
        "ronja-pc"
      ];
      forDevice = f: nixpkgs.lib.mapAttrs f devices;
    in
    rec {
      nixosConfigurations = forDevice (
        device: system:
        let specialArgs = {
          inherit inputs device;
          pkgs-unstable = nixpkgs-unstable.legacyPackages."${system}";
        };
        in nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
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

              { nixpkgs.overlays = [ overlays.unstable-packages ]; }
            ]
            ++ (nixpkgs.lib.optionals (builtins.elem device homeDevices) [
              home-manager.nixosModules.home-manager
              { home-manager.extraSpecialArgs = specialArgs; }
              ./modules/home-manager.nix

              ./modules/i18n.nix

              niri.nixosModules.niri
              { nixpkgs.overlays = [ niri.overlays.niri ]; }
            ]);
        }
      );

      overlays = {
        unstable-packages = final: prev: {
          unstable = import nixpkgs-unstable {
            system = prev.system;
            config = prev.config;
          };
        };
      };

      formatter = {
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
        aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixfmt-rfc-style;
      };
    };
}
