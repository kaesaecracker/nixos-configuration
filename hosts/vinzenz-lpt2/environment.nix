{pkgs, ...}: {
  imports = [
    ../../home
    ../../home/gnome-home.nix
    ../../users/vinzenz.nix
    ../desktop-environment.nix
    ../gnome.nix
    ../gaming.nix
    ../printing.nix
    ../latex.nix
  ];

  config = {
    home-manager.users.vinzenz = import ../../home/vinzenz-home.nix;

    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        autoPrune.enable = true;
      };
    };

    users.users.vinzenz.openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY vinzenz-pixel-JuiceSSH''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1CRn4yYTL4XUdCebE8Z4ZeuMujBjorTdWifg911EOv vinzenz-pc2 home roaming''
    ];
    #
    #users.users.ronja.openssh.authorizedKeys.keys = [
    #  ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALWKm+d6KL6Vl3grPOcGouiNTkvdhXuWJmcrdEBY2nw ronja-ssh-host-key''
    #];
    #
    services.nginx = {
      enable = true;

      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;

      virtualHosts = {
        "vinzenz-lpt2" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:3000/";
            proxyWebsockets = true;
          };

          serverAliases = ["172.23.42.96"];
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [80 8001 3000];
      allowedUDPPorts = [2342];
    };
  };
}
