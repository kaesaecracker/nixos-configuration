{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.my.home;
in {
  imports =
    [
      ./vinzenz.nix
      ./ronja.nix
      # enable home manager
    ]
    ++ lib.optional (builtins.pathExists <home-manager/nixos>) <home-manager/nixos>;

  options.my.home = {
    enable = lib.mkEnableOption "my home management";
  };

  config = lib.mkIf cfg.enable {
    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = true;
  };
}
