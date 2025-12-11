{
  config,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
    self.nixosModules.user-ronja
    self.nixosModules.gnome
    self.nixosModules.steam
    self.nixosModules.wine-gaming
    self.nixosModules.vinzenz-desktop-settings
  ];

  config = {
    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "de";
      variant = "";
    };

    # Configure console keymap
    console.keyMap = "de";

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      #  wget
    ];

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];};
  };
}
