modulesCfg: {lib, ...}: {
  imports =
    [
      ./i18n.nix
      ./nixpkgs.nix
      ./server.nix
    ]
    ++ (map (path: (import path modulesCfg)) [
      ./desktop
      ./hardware
    ]);

  config = {
    my.modulesCfg = modulesCfg;
  };
}
