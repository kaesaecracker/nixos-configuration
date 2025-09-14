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
    in
    {
      lib = {
        importDir =
          dir:
          (lib.attrsets.mapAttrs' (
            m: _:
            lib.attrsets.nameValuePair (lib.strings.removeSuffix ".nix" m) { imports = [ "${dir}/${m}" ]; }
          ) (builtins.readDir dir));
      };

      nixosConfigurations = forDevice (
        device: system:
        let
          commonSpecialArgs = {
            inherit device;
            vinzenzHomeModules = self.homeModules;
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = commonSpecialArgs // {
            vinzenzNixosModules = self.nixosModules;
          };
          modules = [
            {
              networking.hostName = device;
              system = {
                stateVersion = "22.11";
                autoUpgrade.flake = "git+https://git.berlin.ccc.de/vinzenz/nixos-configuration.git";
              };

              nixpkgs.overlays = [
                self.overlays.unstable-packages
              ];

              nix.settings.experimental-features = [
                "nix-command"
                "flakes"
              ];
            }

            ./nixosConfigurations/${device}

            self.nixosModules.lix-is-nix
            self.nixosModules.globalinstalls
            self.nixosModules.autoupdate
            self.nixosModules.openssh
            self.nixosModules.tailscale
            self.nixosModules.allowed-unfree-list
            self.nixosModules.extra-caches
            ./modules/nixpkgs.nix

            zerforschen-plus.nixosModules.default
          ]
          ++ (nixpkgs.lib.optionals (builtins.elem device homeDevices) [
            {
              home-manager = {
                extraSpecialArgs = commonSpecialArgs;
                useGlobalPkgs = true;
                useUserPackages = true;
              };

              time.timeZone = "Europe/Berlin";

              home-manager.sharedModules = [
                { home.stateVersion = "22.11"; }
                self.homeModules.adwaita
                self.homeModules.git
                self.homeModules.templates
                self.homeModules.zsh-basics
                self.homeModules.nano
              ];
            }

            self.nixosModules.pkgs-unstable
            self.nixosModules.pkgs-vscode-extensions
            self.nixosModules.niri
            self.nixosModules.kdeconnect
            self.nixosModules.en-de
            self.nixosModules.gnome
            self.nixosModules.modern-desktop
            self.nixosModules.nix-ld

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
      };

      nixosModules = (self.lib.importDir ./nixosModules) // {
        niri = {
          imports = [ niri.nixosModules.niri ];
          nixpkgs.overlays = [ niri.overlays.niri ];
        };
        pkgs-unstable = {
          nixpkgs.overlays = [ self.overlays.unstable-packages ];
        };
        pkgs-vscode-extensions = {
          nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ];
        };
      };

      homeModules = self.lib.importDir ./homeModules;

      formatter = forAllSystems ({ pkgs, ... }: pkgs.nixfmt-tree);
    };
}
