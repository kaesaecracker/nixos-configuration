{
  config,
  pkgs,
  my-nixos-modules,
  ...
}:
{
  imports = [
    ./hardware.nix
    my-nixos-modules.user-ronja
    my-nixos-modules.gnome
    my-nixos-modules.steam
    my-nixos-modules.wine-gaming
    my-nixos-modules.vinzenz-desktop-settings
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
