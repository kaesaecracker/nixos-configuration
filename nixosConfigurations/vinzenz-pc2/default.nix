{ pkgs, my-nixos-modules, ... }:
{
  imports = [
    ./hardware.nix
    ./vscode-server.nix
    ./hass.nix

    my-nixos-modules.user-vinzenz
    my-nixos-modules.gnome
    my-nixos-modules.wine-gaming
    my-nixos-modules.steam
    my-nixos-modules.podman
    my-nixos-modules.vinzenz-desktop-settings
    my-nixos-modules.amd-graphics
    my-nixos-modules.secure-boot
  ];

  config = {
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

    users.users.vinzenz.openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrY6tcgnoC/xbgL7vxSjddEY9MBxRXe9n2cAHt88/TT home roaming''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY vinzenz-pixel-JuiceSSH''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDNpLDmctyqGpow/ElQvdhY4BLBPS/sigDJ1QEcC7wC vinzenz-lpt2-roaming''
    ];

    environment.systemPackages = with pkgs; [ lact ];

    networking.firewall.allowedUDPPorts = [
      # Factorio
      34197
    ];
  };
}
