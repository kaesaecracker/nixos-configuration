{pkgs, ...}: {
  imports = [
    (import ./modules {
      hostName = "hetzner-vpn1";
      enableDesktop = false;
    })
  ];

  config = {
    my.server.enable = true;

    users.users.root.openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICdYqY3Y1/f1bsAi5Qfyr/UWuX9ixu96IeAlhoQaJkbf''
    ];
  };
}
