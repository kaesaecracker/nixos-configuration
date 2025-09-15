{ lib, config, ... }:
{
  options.allowedUnfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    example = [ "steam" ];
  };

  config = {
    nixpkgs.config = {
      # https://github.com/NixOS/nixpkgs/issues/197325#issuecomment-1579420085
      allowUnfreePredicate = lib.mkDefault (
        pkg: builtins.elem (lib.getName pkg) config.allowedUnfreePackages
      );
    };
  };
}
