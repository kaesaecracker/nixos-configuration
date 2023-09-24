modulesCfg: {lib, ...}: {
  imports =
    [
      ./i18n.nix
      ./nixpkgs.nix
      ./globalinstalls.nix
      ./server.nix
      ./desktop
    ]
    ++ (map (path: (import path modulesCfg)) [
      ./hardware
      ./users
    ]);

  config = {
    my.modulesCfg = modulesCfg;
  };
}
