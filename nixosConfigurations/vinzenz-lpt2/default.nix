{ my-nixos-modules, ... }:
{
  imports = [
    ./hardware.nix
    my-nixos-modules.user-vinzenz
    my-nixos-modules.gnome
    my-nixos-modules.wine-gaming
    my-nixos-modules.steam
    my-nixos-modules.podman
    my-nixos-modules.vinzenz-desktop-settings
    my-nixos-modules.intel-graphics
    my-nixos-modules.secure-boot
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
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY vinzenz-pixel-JuiceSSH''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1CRn4yYTL4XUdCebE8Z4ZeuMujBjorTdWifg911EOv vinzenz-pc2 home roaming''
    ];

    #users.users.ronja.openssh.authorizedKeys.keys = [
    #  ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALWKm+d6KL6Vl3grPOcGouiNTkvdhXuWJmcrdEBY2nw ronja-ssh-host-key''
    #];

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
  };
}
