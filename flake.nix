{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
    {
      self,
      nixpkgs,
      home-manager,
      niri,
      zerforschen-plus,
      nixpkgs-unstable,
      servicepoint-cli,
      servicepoint-simulator,
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
            inherit device;
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            { networking.hostName = device; }

            self.nixosModules.default

            ./hosts/${device}/hardware.nix
            ./hosts/${device}/imports.nix
            ./hosts/${device}/configuration.nix

            {
              nixpkgs.overlays = [
                overlays.unstable-packages
                overlays.zerforschen
              ];
            }
          ]
          ++ (nixpkgs.lib.optionals (builtins.elem device homeDevices) [
            self.nixosModules.desktopDefault
            { home-manager.extraSpecialArgs = specialArgs; }
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

        zerforschen = final: prev: {
          zerforschen-plus-content = zerforschen-plus.packages."${prev.system}".zerforschen-plus-content;
        };
      };

      nixosModules = {
        lix = (import ./nixosModules/lix.nix);
        kdeconnect = (import ./nixosModules/kdeconnect.nix);
        niri = {
          imports = [ niri.nixosModules.niri ];
          nixpkgs.overlays = [ niri.overlays.niri ];
        };
        pkgs-unstable = {
          nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ];
        };
        desktopDefault = {
          imports = [
            self.nixosModules.pkgs-unstable
            self.nixosModules.niri
            self.nixosModules.kdeconnect
            home-manager.nixosModules.home-manager
            servicepoint-simulator.nixosModules.default
            servicepoint-cli.nixosModules.default
            ./modules/home-manager.nix
            ./modules/i18n.nix
          ];
        };
        default = {
          imports = [
            self.nixosModules.lix
            ./modules/globalinstalls.nix
            ./modules/networking.nix
            ./modules/nixpkgs.nix
          ];
        };
      };

      formatter = forAllSystems ({ pkgs, ... }: pkgs.nixfmt-tree);
    };
}
