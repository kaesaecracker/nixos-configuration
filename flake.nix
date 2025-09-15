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
        vinzenz-lpt2 = {
          system = "x86_64-linux";
          additional-modules = [
            self.nixosModules.user-vinzenz

            self.nixosModules.gnome
            self.nixosModules.wine-gaming
            self.nixosModules.steam
            self.nixosModules.printing
            self.nixosModules.podman
            self.nixosModules.vinzenz-desktop-settings
            self.nixosModules.intel-graphics
          ];
          home-manager-users = {
            inherit (self.homeConfigurations) vinzenz;
          };
        };
        vinzenz-pc2 = {
          system = "x86_64-linux";
          additional-modules = [
            self.nixosModules.user-vinzenz
            self.nixosModules.user-ronja

            self.nixosModules.gnome
            self.nixosModules.wine-gaming
            self.nixosModules.steam
            self.nixosModules.printing
            self.nixosModules.podman
            self.nixosModules.vinzenz-desktop-settings
            self.nixosModules.amd-graphics
          ];
          home-manager-users = {
            inherit (self.homeConfigurations) vinzenz ronja;
          };
        };
        ronja-pc = {
          system = "x86_64-linux";
          additional-modules = [
            self.nixosModules.user-ronja

            self.nixosModules.gnome
            self.nixosModules.steam
            self.nixosModules.wine-gaming
            self.nixosModules.vinzenz-desktop-settings
          ];
          home-manager-users = {
            inherit (self.homeConfigurations) ronja;
          };
        };
        hetzner-vpn2 = {
          system = "aarch64-linux";
        };
        forgejo-runner-1 = {
          system = "aarch64-linux";
          additional-modules = [ self.nixosModules.podman ];
        };
      };
      inherit (nixpkgs) lib;
      forDevice = f: lib.mapAttrs (device: value: f (value // { inherit device; })) devices;
      supported-systems = lib.attrsets.mapAttrsToList (k: v: v.system) devices;
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

      overlays = {
        unstable-packages = final: prev: {
          unstable = import nixpkgs-unstable {
            inherit (prev) system config;
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
        # required modules to use other modules, should not do anything on their own
        default = {
          imports = [ self.nixosModules.allowed-unfree-list ];
        };
      };

      homeModules = self.lib.importDir ./homeModules;
      homeConfigurations = self.lib.importDir ./homeConfigurations;

      formatter = forAllSystems ({ pkgs, ... }: pkgs.nixfmt-tree);

      nixosConfigurations = forDevice (
        {
          device,
          system,
          home-manager-users ? { },
          additional-modules ? [ ],
        }:
        let
          specialArgs = {
            inherit device;
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            {
              networking.hostName = device;
              nixpkgs = {
                inherit system;
                hostPlatform = lib.mkDefault system;
              };
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

              documentation = {
                info.enable = false; # info pages and the info command
                doc.enable = false; # documentation distributed in packages' /share/doc
              };
            }

            ./nixosConfigurations/${device}

            self.nixosModules.default
            self.nixosModules.lix-is-nix
            self.nixosModules.globalinstalls
            self.nixosModules.autoupdate
            self.nixosModules.openssh
            self.nixosModules.tailscale
            self.nixosModules.allowed-unfree-list
            self.nixosModules.extra-caches
            self.nixosModules.systemd-boot

            zerforschen-plus.nixosModules.default
          ]
          ++ (nixpkgs.lib.optionals (home-manager-users != { }) [
            {
              home-manager = {
                extraSpecialArgs = specialArgs;
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
                self.homeModules.gnome-extensions
              ];

              home-manager.users = home-manager-users;
            }

            self.nixosModules.pkgs-unstable
            self.nixosModules.pkgs-vscode-extensions
            self.nixosModules.niri
            self.nixosModules.kdeconnect
            self.nixosModules.en-de
            self.nixosModules.gnome
            self.nixosModules.modern-desktop
            self.nixosModules.nix-ld
            self.nixosModules.quiet-boot
            self.nixosModules.firmware-updates

            home-manager.nixosModules.home-manager
            servicepoint-simulator.nixosModules.default
            servicepoint-cli.nixosModules.default
          ])
          ++ additional-modules;
        }
      );
    };
}
