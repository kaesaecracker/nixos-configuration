{ lib, ... }:
{
  imports = [
    ./hardware.nix
    ./nice-looking-console.nix
  ];

  users.users.ruth = {
    # initialPassword = "setup";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    # Allow the graphical user to login without password
    initialHashedPassword = "";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDNpLDmctyqGpow/ElQvdhY4BLBPS/sigDJ1QEcC7wC lpt2-roaming"
    ];
  };
  nix.settings.trusted-users = [ "ruth" ];

  # Don't require sudo/root to `reboot` or `poweroff`.
  security.polkit.enable = true;

  # Allow passwordless sudo from nixos user
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services.openssh.enable = true;

  # https://github.com/nvmd/nixos-raspberrypi-demo/blob/c521600570f0365ae9c846af4b023049b80ae331/modules/server-networking.nix

  networking.firewall.logRefusedConnections = lib.mkDefault false;

  # Use networkd instead of the pile of shell scripts
  # NOTE: SK: is it safe to combine with NetworkManager on desktops?
  networking.useNetworkd = lib.mkDefault true;

  # The notion of "online" is a broken concept
  # https://github.com/systemd/systemd/blob/e1b45a756f71deac8c1aa9a008bd0dab47f64777/NEWS#L13
  # https://github.com/NixOS/nixpkgs/issues/247608
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.network.wait-online.enable = false;

  # Do not take down the network for too long when upgrading,
  # This also prevents failures of services that are restarted instead of stopped.
  # It will use `systemctl restart` rather than stopping it with `systemctl stop`
  # followed by a delayed `systemctl start`.
  systemd.services.systemd-networkd.stopIfChanged = false;
  # Services that are only restarted might be not able to resolve when resolved is stopped before
  systemd.services.systemd-resolved.stopIfChanged = false;
}
