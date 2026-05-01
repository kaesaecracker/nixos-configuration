{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.my.lixIsNix.enable = lib.mkEnableOption "Lix as the Nix implementation";

  config = lib.mkIf config.my.lixIsNix.enable {
    nixpkgs.overlays = [
      (_: prev: {
        inherit (prev.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena
          ;
      })
    ];

    nix.package = pkgs.lixPackageSets.latest.lix;
  };
}
