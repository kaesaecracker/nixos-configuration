{pkgs, ...}: {
  imports = [
    (import ./modules {
      hostName = "vinzenz-lpt2";
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
        dotnet = true;
        js = true;
        rust = true;
        native = true;
      };

      allowUnfreePackages = [
        "rider"
        "clion"
        "pycharm-professional"
      ];
    };

    environment.systemPackages = with pkgs; [anydesk];

    virtualisation.podman = {
      enable = true;
    };

    users.users.vinzenz.openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY vinzenz-pixel-JuiceSSH''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1CRn4yYTL4XUdCebE8Z4ZeuMujBjorTdWifg911EOv vinzenz-pc2 home roaming''
    ];

    users.users.ronja.openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALWKm+d6KL6Vl3grPOcGouiNTkvdhXuWJmcrdEBY2nw ronja-ssh-host-key''
    ];
  };
}
