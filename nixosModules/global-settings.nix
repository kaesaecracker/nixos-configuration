{
  device,
  self,
  lanzaboote,
  zerforschen-plus,
  ...
}:
{
  imports = [
    # keep-sorted start
    lanzaboote.nixosModules.lanzaboote
    self.nixosModules.allowed-unfree-list
    self.nixosModules.autoupdate
    self.nixosModules.default
    self.nixosModules.extra-caches
    self.nixosModules.globalinstalls
    self.nixosModules.lix-is-nix
    self.nixosModules.openssh
    self.nixosModules.prometheus-node
    self.nixosModules.systemd-boot
    self.nixosModules.tailscale
    zerforschen-plus.nixosModules.default
    # keep-sorted end
  ];

  config = {
    networking.hostName = device;
    system = {
      stateVersion = "22.11";
      autoUpgrade.flake = "git+https://git.berlin.ccc.de/vinzenz/nixos-configuration.git";
    };

    nixpkgs.overlays = [
      self.overlays.unstable-packages
    ];

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    documentation = {
      info.enable = false; # info pages and the info command
      doc.enable = false; # documentation distributed in packages' /share/doc
    };
  };
}
