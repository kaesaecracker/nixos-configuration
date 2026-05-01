{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    #    ./vscode-server.nix
    #    ./hass.nix
  ];

  config = {
    my.users.muede.enable = true;
    my.wineGaming.enable = true;
    my.steam.enable = true;
    my.podman.enable = true;
    my.muedeDesktopSettings.enable = true;
    my.amdGraphics.enable = true;
    my.secureBoot.enable = true;

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
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

    users.users.muede.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrY6tcgnoC/xbgL7vxSjddEY9MBxRXe9n2cAHt88/TT home roaming"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY pixel-JuiceSSH"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDNpLDmctyqGpow/ElQvdhY4BLBPS/sigDJ1QEcC7wC lpt2-roaming"
    ];

    environment.systemPackages = with pkgs; [ lact ];

    networking.firewall.allowedUDPPorts = [
      # Factorio
      34197
    ];
  };
}
