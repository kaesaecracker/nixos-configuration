{ nixpkgs, common-modules, ... }:
nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";
  modules = common-modules ++ [
    ./hardware.nix
    ../../users/vinzenz.nix
    { networking.hostName = "forgejo-runner-1"; }
    {
      # uncomment for build check on non arm system (requires --impure)
      # nixpkgs.buildPlatform = builtins.currentSystem;
    }
    {
      services.tailscale.useRoutingFeatures = "both";
    }
    {
      users.users = {
        root.openssh.authorizedKeys.keys = [
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY vinzenz-pixel-JuiceSSH''
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1CRn4yYTL4XUdCebE8Z4ZeuMujBjorTdWifg911EOv vinzenz-pc2 home roaming''
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDNpLDmctyqGpow/ElQvdhY4BLBPS/sigDJ1QEcC7wC vinzenz-lpt2-roaming''
        ];
      };
    }
    {
      system.autoUpgrade.allowReboot = true;
    }
  ];
}
