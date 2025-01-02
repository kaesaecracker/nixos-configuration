{
  nixpkgs,
  common-modules,
  desktop-modules,
  ...
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules =
    common-modules
    ++ desktop-modules
    ++ [
      ./hardware.nix
      ./nginx.nix

      ../../home/gnome.nix
      ../../users/vinzenz.nix
      ../../modules/gnome.nix
      ../../modules/gaming.nix
      ../../modules/printing.nix
      ../../modules/podman.nix

      {
        networking.hostName = "vinzenz-lpt2";
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
      }

      {
        home-manager.users.vinzenz = import ../../home/vinzenz;

        users.users.vinzenz.openssh.authorizedKeys.keys = [
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY vinzenz-pixel-JuiceSSH''
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1CRn4yYTL4XUdCebE8Z4ZeuMujBjorTdWifg911EOv vinzenz-pc2 home roaming''
        ];

        #users.users.ronja.openssh.authorizedKeys.keys = [
        #  ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALWKm+d6KL6Vl3grPOcGouiNTkvdhXuWJmcrdEBY2nw ronja-ssh-host-key''
        #];
      }

      {
        programs.adb.enable = true;
      }
    ];
}
