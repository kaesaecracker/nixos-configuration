{ self, pkgs, ... }:
{
  imports = [
    ./containers.nix
    ./hardware.nix
    ./hyperhive.nix
  ];

  config = {
    my = {
      # keep-sorted start
      intelGraphics.enable = true;
      muedeDesktopSettings.enable = true;
      podman.enable = true;
      secureBoot.enable = true;
      steam.enable = true;
      users.muede.enable = true;
      wineGaming.enable = true;
      # keep-sorted end
    };

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

    users.users.muede.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY pixel-JuiceSSH"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1CRn4yYTL4XUdCebE8Z4ZeuMujBjorTdWifg911EOv pc2 home roaming"
    ];

    # `programs.adb` removed in nixpkgs 26.05 (systemd 258 handles uaccess); add pkgs.android-tools to systemPackages if adb is needed
    # `programs.light` removed in nixpkgs 26.05; replace with brightnessctl or hardware.acpilight when re-enabling
    environment.systemPackages = [ pkgs.android-tools ];

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
