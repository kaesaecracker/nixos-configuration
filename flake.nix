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
      # keep-sorted start
      niri,
      nix-vscode-extensions,
      nixpkgs-unstable,
      treefmt-nix,
      # keep-sorted end
      ...
    }:
    let
      inherit (nixpkgs) lib;
      nixosConfigurations = import ./nixosConfigurations.nix { inherit inputs lib; };
      supported-systems = lib.unique (lib.mapAttrsToList (_: v: v.pkgs.system) nixosConfigurations);
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
        unstable = final: prev: {
          unstable = import nixpkgs-unstable {
            localSystem = prev.stdenv.hostPlatform;
            inherit (prev) config;
          };
        };
        vscodeExtensions = nix-vscode-extensions.overlays.default;
        niri = niri.overlays.niri;
      };

      nixosModules = (importModuleDir ./nixosModules) // {
        default = {
          imports = builtins.attrValues (builtins.removeAttrs self.nixosModules [ "default" ]);
        };
      };

      homeModules = importModuleDir ./homeModules;
      homeConfigurations = {
        muede = ./homeConfigurations/muede;
        ronja = ./homeConfigurations/ronja;
      };

      inherit nixosConfigurations;

      formatter = forAllSystems ({ treefmt-eval, ... }: treefmt-eval.config.build.wrapper);

      checks = forAllSystems (
        { treefmt-eval, ... }:
        {
          formatting = treefmt-eval.config.build.check self;
        }
      );
    };
}
