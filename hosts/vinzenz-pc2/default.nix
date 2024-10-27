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
      ./vscode-server.nix
      ../../home/gnome.nix
      ../../users/vinzenz.nix
      ../../users/ronja.nix
      ../../modules/gnome.nix
      ../../modules/gaming.nix
      ../../modules/printing.nix
      ../../modules/podman.nix
      { networking.hostName = "vinzenz-pc2"; }
      {
        home-manager.users = {
          vinzenz = import ../../home/vinzenz;
          ronja = import ../../home/ronja.nix;
        };

        users.users.vinzenz.openssh.authorizedKeys.keys = [
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrY6tcgnoC/xbgL7vxSjddEY9MBxRXe9n2cAHt88/TT home roaming''
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY vinzenz-pixel-JuiceSSH''
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDNpLDmctyqGpow/ElQvdhY4BLBPS/sigDJ1QEcC7wC vinzenz-lpt2-roaming''
        ];

        users.users.ronja.openssh.authorizedKeys.keys = [
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALWKm+d6KL6Vl3grPOcGouiNTkvdhXuWJmcrdEBY2nw ssh-host-key''
        ];
      }
    ];
}
