{
  nixpkgs,
  common-modules,
  desktop-modules,
  ...
}:
nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";
  modules =
    common-modules
    ++ [
      ./hardware.nix
      ./nginx.nix
      ../../users/vinzenz.nix
      ../../users/ronja.nix
      {
        networking.hostName = "hetzner-vpn1";
      }
      {
        # uncomment for build check on non arm system (requires --impure)
        # nixpkgs.buildPlatform = builtins.currentSystem;
      }
      {
        users.users = {
          root.openssh.authorizedKeys.keys = [
            ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICdYqY3Y1/f1bsAi5Qfyr/UWuX9ixu96IeAlhoQaJkbf''
            ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY vinzenz-pixel-JuiceSSH''
            ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1CRn4yYTL4XUdCebE8Z4ZeuMujBjorTdWifg911EOv vinzenz-pc2 home roaming''
            ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDNpLDmctyqGpow/ElQvdhY4BLBPS/sigDJ1QEcC7wC vinzenz-lpt2-roaming''
          ];
          vinzenz.openssh.authorizedKeys.keys = [
            ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICdYqY3Y1/f1bsAi5Qfyr/UWuX9ixu96IeAlhoQaJkbf''
            ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY vinzenz-pixel-JuiceSSH''
            ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1CRn4yYTL4XUdCebE8Z4ZeuMujBjorTdWifg911EOv vinzenz-pc2 home roaming''
            ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDNpLDmctyqGpow/ElQvdhY4BLBPS/sigDJ1QEcC7wC vinzenz-lpt2-roaming''
          ];
          ronja.openssh.authorizedKeys.keys = [
            ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALWKm+d6KL6Vl3grPOcGouiNTkvdhXuWJmcrdEBY2nw ronja-ssh-host-key''
          ];
        };
      }
    ];
}
