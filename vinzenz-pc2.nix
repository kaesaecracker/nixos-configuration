{pkgs, ...}: {
  imports = [
    (import ./modules {
      hostName = "vinzenz-pc2";
      enableHomeManager = true;
    })
  ];

  config = {
    my = {
      enabledUsers = ["vinzenz" "ronja"];
      tailscale.enable = true;
      desktop = {
        enableGnome = true;
        enableGaming = true;
        enablePrinting = true;
      };
      buildtools = {
        native = true;
        dotnet = true;
        rust = true;
        jetbrains-remote-server = true;
      };
    };

    users.users.vinzenz.openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrY6tcgnoC/xbgL7vxSjddEY9MBxRXe9n2cAHt88/TT home roaming''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY vinzenz-pixel-JuiceSSH''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDNpLDmctyqGpow/ElQvdhY4BLBPS/sigDJ1QEcC7wC vinzenz-lpt2-roaming''
    ];

    services.openvscode-server = {
      enable = true;
      telemetryLevel = "off";
      port = 8542;
      host = "100.125.93.127"; # tailscale
      withoutConnectionToken = true;
      extraPackages = with pkgs; [nodejs gitFull gh];
    };

    networking.firewall = {
      allowedTCPPorts = [8542 8543 8544];
    };
  };
}
