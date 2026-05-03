{
  inputs,
  lib,
}:
let
  allDevices = import ./devices.nix { inherit (inputs) self; };
  inherit (inputs)
    self
    home-manager
    lanzaboote
    nova-shell
    servicepoint-cli
    servicepoint-simulator
    servicepoint-tanks
    stylix
    zerforschen-plus
    ;
  forDevice = f: lib.mapAttrs (device: value: f (value // { inherit device; })) allDevices;
in
forDevice (
  {
    device,
    system,
    isDesktop ? false,
    home-manager-users ? { },
    nixosSystem ? inputs.nixpkgs.lib.nixosSystem,
    ...
  }@thisDevice:
  let
    specialArgs = inputs // {
      inherit
        device
        home-manager-users
        allDevices
        thisDevice
        ;
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
      servicepoint-cli.nixosModules.default
      servicepoint-simulator.nixosModules.default
      servicepoint-tanks.nixosModules.default
      stylix.nixosModules.stylix
      zerforschen-plus.nixosModules.default
      # keep-sorted end

      # Base config
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

        my = {
          # keep-sorted start
          autoupdate.enable = true;
          distributedBuilds.enable = true;
          extraCaches.enable = true;
          git.enable = true;
          globalinstalls.enable = true;
          lixIsNix.enable = true;
          openssh.enable = true;
          overlays.unstable.enable = true;
          overlays.vscodeExtensions.enable = true;
          # prometheusNode.enable = true;
          systemdBoot.enable = true;
          tailscale.enable = true;
          # keep-sorted end
        };
      }
    ]
    ++ lib.optionals isDesktop [
      # Desktop config
      {
        home-manager = {
          extraSpecialArgs = specialArgs;
          useGlobalPkgs = true;
          useUserPackages = true;
          users = home-manager-users;
          sharedModules = [ { home.stateVersion = "22.11"; } ] ++ builtins.attrValues self.homeModules;
        };

        time.timeZone = "Europe/Berlin";

        # on desktops, keep the device useable interactively during expensive builds
        nix = {
          daemonCPUSchedPolicy = "idle";
          daemonIOSchedClass = "idle";
        };

        my = {
          # keep-sorted start
          enDe.enable = true;
          firmwareUpdates.enable = true;
          gnome.enable = true;
          kdeconnect.enable = true;
          modernDesktop.enable = true;
          nixLd.enable = true;
          quietBoot.enable = true;
          stylix.enable = true;
          # keep-sorted end
        };
      }
    ];
  }
)
