{ self, ... }:
{
  imports = [
    ./hardware.nix
    self.nixosModules.user-vinzenz
    self.nixosModules.gnome
    self.nixosModules.wine-gaming
    self.nixosModules.steam
    self.nixosModules.podman
    self.nixosModules.vinzenz-desktop-settings
    self.nixosModules.intel-graphics
    self.nixosModules.secure-boot
  ];

  config = {
    nix.settings.extra-platforms = [
      "aarch64-linux"
      "i686-linux"
    ];

    services.xserver.xkb = {
      # Configure keymap in X11
      layout = "de";
      variant = "";
    };

    # Configure console keymap
    console.keyMap = "de";

    users.users.vinzenz.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY vinzenz-pixel-JuiceSSH"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1CRn4yYTL4XUdCebE8Z4ZeuMujBjorTdWifg911EOv vinzenz-pc2 home roaming"
    ];

    programs = {
      adb.enable = true;
      light = {
        enable = true;
        brightnessKeys = {
          enable = true;
          step = 5;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      8776
      1337
    ];

    services.servicepoint-tanks = {
      enable = false;
      urls = [
        "http://localhost:5666"
        "http://localhost:5667"
      ];
    };
    nixpkgs.config.permittedInsecurePackages = [
      "mbedtls-2.28.10"
    ];

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
