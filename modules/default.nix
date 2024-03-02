modulesCfg: {lib, ...}: {
  imports =
    [
      ./i18n.nix
      ./nixpkgs.nix
      ./globalinstalls.nix
      ./sshd.nix
      ./tailscale.nix
      ./buildtools.nix
    ]
    ++ (map (path: (import path modulesCfg)) [
      ./hardware
      ./users
      ./desktop
    ]);

  config = {
    my.modulesCfg = modulesCfg;

    networking.firewall = {
      enable = true;
      checkReversePath = "loose";
    };
  };
}
