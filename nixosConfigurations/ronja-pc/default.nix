{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
  ];

  config = {
    my = {
      # keep-sorted start
      muedeDesktopSettings.enable = true;
      steam.enable = true;
      users.ronja.enable = true;
      wineGaming.enable = true;
      # keep-sorted end
    };

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "de";
      variant = "";
    };

    # Configure console keymap
    console.keyMap = "de";

    environment.systemPackages = with pkgs; [
      #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      #  wget
    ];

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];};
  };
}
