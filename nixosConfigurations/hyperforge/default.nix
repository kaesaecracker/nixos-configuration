{
  imports = [
    ./hardware.nix
    ./forgejo.nix
    ./nginx.nix
  ];

  config = {
    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY pixel-JuiceSSH"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1CRn4yYTL4XUdCebE8Z4ZeuMujBjorTdWifg911EOv pc2 home roaming"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDNpLDmctyqGpow/ElQvdhY4BLBPS/sigDJ1QEcC7wC lpt2-roaming"
    ];
  };
}
