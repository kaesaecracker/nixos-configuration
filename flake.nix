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
      lib = nixpkgs.lib;
      forDevice = f: lib.mapAttrs f devices;
      supported-systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems =
        f:
        lib.genAttrs supported-systems (
          system:
          f rec {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        );
      importDir =
        dir:
        (lib.attrsets.mapAttrs' (
          m: _:
          lib.attrsets.nameValuePair (lib.strings.removeSuffix ".nix" m) { imports = [ "${dir}/${m}" ]; }
        ) (builtins.readDir dir));
    in
    rec {
      nixosConfigurations = forDevice (
        device: system:
        let
          specialArgs = {
            inherit device;
            inherit (self) nixosModules;
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            {
              networking.hostName = device;
              system = {
                stateVersion = "22.11";
                autoUpgrade.flake = "git+https://git.berlin.ccc.de/vinzenz/nixos-configuration.git";
              };

              nixpkgs.overlays = [
                overlays.unstable-packages
                overlays.zerforschen
              ];

              nix.settings.experimental-features = [
                "nix-command"
                "flakes"
              ];
            }

            ./hosts/${device}/hardware.nix
            ./hosts/${device}/imports.nix
            ./hosts/${device}/configuration.nix

            self.nixosModules.lix-is-nix
            self.nixosModules.globalinstalls
            self.nixosModules.autoupdate
            self.nixosModules.openssh
            self.nixosModules.tailscale
            self.nixosModules.allowed-unfree-list
            self.nixosModules.extra-caches
            ./modules/nixpkgs.nix
          ]
          ++ (nixpkgs.lib.optionals (builtins.elem device homeDevices) [
            {
              home-manager.extraSpecialArgs = specialArgs;

              time.timeZone = "Europe/Berlin";

              home-manager.sharedModules = [
                self.homeModules.adwaita
              ];
            }

            self.nixosModules.pkgs-unstable
            self.nixosModules.niri
            self.nixosModules.kdeconnect
            self.nixosModules.en-de
            self.nixosModules.gnome
            ./modules/home-manager.nix

            home-manager.nixosModules.home-manager
            servicepoint-simulator.nixosModules.default
            servicepoint-cli.nixosModules.default
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

      nixosModules = (importDir ./nixosModules) // {
        niri = {
          imports = [ niri.nixosModules.niri ];
          nixpkgs.overlays = [ niri.overlays.niri ];
        };
        pkgs-unstable = {
          nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ];
        };
      };

      homeModules = importDir ./homeModules;

      formatter = forAllSystems ({ pkgs, ... }: pkgs.nixfmt-tree);
    };
}
