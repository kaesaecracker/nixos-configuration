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
      nixpkgs-unstable,
      nova-shell,
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
      devices = import ./devices.nix { inherit self; };
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
          { lib, config, ... }:
          {
            imports = [ niri.nixosModules.niri ];

            options.my.niri.enable = lib.mkEnableOption "niri wayland compositor";

            config = lib.mkIf config.my.niri.enable {
              nixpkgs.overlays = [ niri.overlays.niri ];
              programs.niri = {
                enable = true;
                #package = pkgs.niri-stable;
              };
            };
          };
        pkgs-unstable = {
          nixpkgs.overlays = [ self.overlays.unstable-packages ];
        };
        pkgs-vscode-extensions = {
          nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ];
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
            ./nixosConfigurations/${device}
            self.nixosModules.default

            # keep-sorted start
            home-manager.nixosModules.home-manager
            lanzaboote.nixosModules.lanzaboote
            nova-shell.nixosModules.default
            self.nixosModules.niri
            self.nixosModules.pkgs-vscode-extensions
            servicepoint-cli.nixosModules.default
            servicepoint-simulator.nixosModules.default
            servicepoint-tanks.nixosModules.default
            stylix.nixosModules.stylix
            zerforschen-plus.nixosModules.default
            # keep-sorted end

            # Base config (replaces global-settings.nix)
            {
              nixpkgs.hostPlatform = lib.mkDefault system;
              networking.hostName = device;
              system = {
                stateVersion = "22.11";
                autoUpgrade.flake = "git+https://git.berlin.ccc.de/vinzenz/nixos-configuration.git";
              };
              nix.settings.experimental-features = [
                "nix-command"
                "flakes"
              ];
              documentation = {
                info.enable = false;
                doc.enable = false;
              };

              my.autoupdate.enable = true;
              my.distributedBuilds.enable = true;
              my.extraCaches.enable = true;
              my.globalinstalls.enable = true;
              my.lixIsNix.enable = true;
              my.openssh.enable = true;
              my.prometheusNode.enable = true;
              my.systemdBoot.enable = true;
              my.tailscale.enable = true;
            }
          ]
          ++ lib.optionals (home-manager-users != { }) [
            # Desktop config (replaces global-settings-desktop.nix)
            {
              home-manager = {
                extraSpecialArgs = specialArgs;
                useGlobalPkgs = true;
                useUserPackages = true;
                users = home-manager-users;
                sharedModules = [
                  { home.stateVersion = "22.11"; }
                  # keep-sorted start
                  self.homeModules.git
                  self.homeModules.gnome-extensions
                  self.homeModules.nano
                  self.homeModules.templates
                  self.homeModules.zsh-basics
                  # keep-sorted end
                ];
              };

              time.timeZone = "Europe/Berlin";

              # on desktops, keep the device useable interactively during expensive builds
              nix = {
                daemonCPUSchedPolicy = "idle";
                daemonIOSchedClass = "idle";
              };

              my.enDe.enable = true;
              my.firmwareUpdates.enable = true;
              my.gnome.enable = true;
              my.kdeconnect.enable = true;
              my.modernDesktop.enable = true;
              my.niri.enable = true;
              my.nixLd.enable = true;
              my.quietBoot.enable = true;
              my.stylix.enable = true;
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
