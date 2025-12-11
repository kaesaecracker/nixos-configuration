{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #keep-sorted start block=yes
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    nix-filter.url = "github:numtide/nix-filter";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    servicepoint-cli = {
      url = "git+https://git.berlin.ccc.de/servicepoint/servicepoint-cli.git";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        naersk.follows = "naersk";
        nix-filter.follows = "nix-filter";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    servicepoint-simulator = {
      url = "git+https://git.berlin.ccc.de/servicepoint/servicepoint-simulator.git";
      inputs = {
        # TODO: update flake to 25.11
        # nixpkgs.follows = "nixpkgs";
        naersk.follows = "naersk";
        nix-filter.follows = "nix-filter";
      };
    };
    servicepoint-tanks = {
      url = "git+https://git.berlin.ccc.de/vinzenz/servicepoint-tanks.git?ref=service-improvements";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nur.follows = "nur";
        flake-parts.follows = "flake-parts";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zerforschen-plus = {
      url = "git+https://git.berlin.ccc.de/vinzenz/zerforschen.plus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #keep-sorted end
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      # keep-sorted start
      lanzaboote,
      niri,
      nix-vscode-extensions,
      nixpkgs-unstable,
      servicepoint-cli,
      servicepoint-simulator,
      servicepoint-tanks,
      stylix,
      treefmt-nix,
      zerforschen-plus,
      # keep-sorted end
      ...
    }:
    let
      devices = {
        vinzenz-lpt2 = {
          system = "x86_64-linux";
          home-manager-users = {
            inherit (self.homeConfigurations) vinzenz;
          };
        };
        vinzenz-pc2 = {
          system = "x86_64-linux";
          home-manager-users = {
            inherit (self.homeConfigurations) vinzenz;
          };
        };
        ronja-pc = {
          system = "x86_64-linux";
          home-manager-users = {
            inherit (self.homeConfigurations) ronja;
          };
        };
        hetzner-vpn2 = {
          system = "aarch64-linux";
        };
        forgejo-runner-1 = {
          system = "aarch64-linux";
        };
        epimetheus = {
          system = "aarch64-linux";
        };
      };
      inherit (nixpkgs) lib;
      forDevice = f: lib.mapAttrs (device: value: f (value // { inherit device; })) devices;
      supported-systems = lib.attrsets.mapAttrsToList (k: v: v.system) devices;
      treefmt-config = {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          jsonfmt.enable = true;
          prettier.enable = true;
          keep-sorted.enable = true;
        };
      };
      forAllSystems =
        f:
        lib.genAttrs supported-systems (
          system:
          f rec {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
            treefmt-eval = treefmt-nix.lib.evalModule pkgs treefmt-config;
          }
        );
      importModuleDir =
        directory:
        nixpkgs.lib.packagesFromDirectoryRecursive {
          inherit directory;
          callPackage = path: _args: path;
        };
    in
    {
      overlays = {
        unstable-packages = final: prev: {
          unstable = import nixpkgs-unstable {
            inherit (prev) system config;
          };
        };
      };

      nixosModules = (importModuleDir ./nixosModules) // {
        niri =
          { pkgs, ... }:
          {
            imports = [ niri.nixosModules.niri ];
            nixpkgs.overlays = [ niri.overlays.niri ];

            programs.niri = {
              enable = true;
              #package = pkgs.niri-stable;
            };
          };
        pkgs-unstable = {
          nixpkgs.overlays = [ self.overlays.unstable-packages ];
        };
        pkgs-vscode-extensions = {
          nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ];
        };
        # required modules to use other modules, should not do anything on their own
        default = {
          imports = [ self.nixosModules.allowed-unfree-list ];
        };
      };

      homeModules = importModuleDir ./homeModules;
      homeConfigurations = {
        vinzenz = ./homeConfigurations/vinzenz;
        ronja = ./homeConfigurations/ronja;
      };

      nixosConfigurations = forDevice (
        {
          device,
          system,
          home-manager-users ? { },
        }:
        let
          specialArgs = inputs // {
            inherit device home-manager-users;
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            {
              imports = [
                ./nixosConfigurations/${device}
                self.nixosModules.global-settings
              ]
              ++ (lib.optionals (home-manager-users != { }) [
                self.nixosModules.global-settings-desktop
              ]);

              nixpkgs = {
                inherit system;
                hostPlatform = lib.mkDefault system;
              };
            }
          ];
        }
      );

      formatter = forAllSystems ({ treefmt-eval, ... }: treefmt-eval.config.build.wrapper);

      checks = forAllSystems (
        { treefmt-eval, ... }:
        {
          formatting = treefmt-eval.config.build.check self;
        }
      );
    };
}
