{pkgs, ...}: {
  imports = [
    ../../home
    ../../home/gnome.nix
    ../../users/vinzenz.nix
    ../../users/ronja.nix
    ../../modules/desktop-environment.nix
    ../../modules/gnome.nix
    ../../modules/gaming.nix
    ../../modules/printing.nix
  ];

  config = {
    home-manager.users = {
      vinzenz = import ../../home/vinzenz;
      ronja = import ../../home/ronja.nix;
    };

    users.users.vinzenz.openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrY6tcgnoC/xbgL7vxSjddEY9MBxRXe9n2cAHt88/TT home roaming''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY vinzenz-pixel-JuiceSSH''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDNpLDmctyqGpow/ElQvdhY4BLBPS/sigDJ1QEcC7wC vinzenz-lpt2-roaming''
    ];

    users.users.ronja.openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALWKm+d6KL6Vl3grPOcGouiNTkvdhXuWJmcrdEBY2nw ssh-host-key''
    ];

    services.openvscode-server = {
      enable = true;
      telemetryLevel = "off";
      port = 8542;
      host = "100.125.93.127"; # tailscale
      withoutConnectionToken = true;
      extraPackages = with pkgs; [nodejs git gh direnv];
    };

    virtualisation.podman = {
      enable = true;
    };

    networking = {
      firewall = {
        allowedTCPPorts = [8542 8543 8544 80];
      };

      interfaces.eno1.wakeOnLan.enable = true;
    };
  };
}
