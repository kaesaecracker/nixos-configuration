{...}: {
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
    ];
  };
}
