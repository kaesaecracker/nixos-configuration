{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
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

    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    servicepoint-cli = {
      url = "git+https://git.berlin.ccc.de/servicepoint/servicepoint-cli.git";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        naersk.follows = "naersk";
      };
    };

    servicepoint-simulator = {
      url = "git+https://git.berlin.ccc.de/servicepoint/servicepoint-simulator.git";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        naersk.follows = "naersk";
      };
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
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
      servicepoint-cli,
      servicepoint-simulator,
      naersk,
      nix-vscode-extensions,
      ...
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
      supported-systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs supported-systems (
          system:
          f rec {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        );
    in
    rec {
      nixosConfigurations = forDevice (
        device: system:
        let
          specialArgs = {
            inherit inputs device;
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            lix-module.nixosModules.default

            { networking.hostName = device; }

            ./modules/globalinstalls.nix
            ./modules/networking.nix
            ./modules/nixpkgs.nix

            ./hosts/${device}/hardware.nix
            ./hosts/${device}/imports.nix
            ./hosts/${device}/configuration.nix

            {
              nixpkgs.overlays = [
                overlays.unstable-packages
              ];
            }
          ]
          ++ (nixpkgs.lib.optionals (builtins.elem device homeDevices) [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            ./modules/home-manager.nix

            ./modules/i18n.nix

            niri.nixosModules.niri
            {
              nixpkgs.overlays = [
                niri.overlays.niri
                overlays.servicepoint-packages
                nix-vscode-extensions.overlays.default
              ];
            }
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
        servicepoint-packages = final: prev: {
          servicepoint-cli = servicepoint-cli.legacyPackages."${prev.system}".servicepoint-cli;
          servicepoint-simulator =
            servicepoint-simulator.legacyPackages."${prev.system}".servicepoint-simulator;
        };
      };

      formatter = forAllSystems ({ pkgs, ... }: pkgs.nixfmt-tree);
    };
}
