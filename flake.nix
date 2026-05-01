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
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };
    nix-filter.url = "github:numtide/nix-filter";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi/main";
    };
    nova-shell = {
      url = "git+https://git.berlin.ccc.de/vinzenz/nova-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
      nixos-generators,
      nixos-raspberrypi,
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
        # keep-sorted start block=yes
        aur0ra = {
          system = "aarch64-linux";
          nixosSystem = nixos-raspberrypi.lib.nixosSystem;
        };
        aur0ra-installer = {
          # build with nix build .\#nixosConfigurations.aur0ra-installer.config.system.build.sdImage
          system = "aarch64-linux";
          nixosSystem = nixos-raspberrypi.lib.nixosInstaller;
        };
        damocles = {
          system = "x86_64-linux";
          distributedBuilds.maxJobs = 0;
        };
        damocles-lab = {
          system = "x86_64-linux";
          distributedBuilds.maxJobs = 0;
        };
        epimetheus = {
          system = "aarch64-linux";
        };
        forgejo-runner-1 = {
          system = "aarch64-linux";
        };
        hetzner-vpn2 = {
          system = "aarch64-linux";
        };
        muede-lpt2 = {
          system = "x86_64-linux";
          home-manager-users = {
            inherit (self.homeConfigurations) muede;
          };
          distributedBuilds = {
            isBuilder = true;
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKAbojdhb3PfazSRmudvo381Y+zUFVLMa7AbWbfK/Zp2 muede-lpt2-nix-builds";
          };
        };
        muede-pc2 = {
          system = "x86_64-linux";
          home-manager-users = {
            inherit (self.homeConfigurations) muede;
          };
          distributedBuilds = {
            isBuilder = true;
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHmnyhP6L+kGHV15cb/d31AQr50wSEaQhkUBwy2+OEKk muede-pc2-nix-builds";
          };
        };
        ronja-pc = {
          system = "x86_64-linux";
          home-manager-users = {
            inherit (self.homeConfigurations) ronja;
          };
        };
        # keep-sorted end
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
            localSystem = prev.stdenv.hostPlatform;
            inherit (prev) config;
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
        muede = ./homeConfigurations/muede;
        ronja = ./homeConfigurations/ronja;
      };

      nixosConfigurations = forDevice (
        {
          device,
          system,
          home-manager-users ? { },
          nixosSystem ? nixpkgs.lib.nixosSystem,
          ...
        }:
        let
          specialArgs = inputs // {
            inherit device home-manager-users devices;
          };
        in
        nixosSystem {
          inherit specialArgs;
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
