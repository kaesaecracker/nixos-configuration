modulesCfg: {lib, ...}: {
  imports =
    [
      ./i18n.nix
      ./nixpkgs.nix
      ./globalinstalls.nix
      ./server.nix
      ./sshd.nix
    ]
    ++ (map (path: (import path modulesCfg)) [
      ./hardware
      ./users
      ./desktop
    ]);

  config = {
    my.modulesCfg = modulesCfg;
  };
}
