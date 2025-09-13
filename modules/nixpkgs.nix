{ config, lib, ... }:
{
  options.allowedUnfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    example = [ "steam" ];
  };
  config = {
    nixpkgs.config = {
      # https://github.com/NixOS/nixpkgs/issues/197325#issuecomment-1579420085
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.allowedUnfreePackages;
    };

    nix.settings = {
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://cache.lix.systems"
        "https://niri.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    documentation = {
      enable = true; # documentation of packages
      nixos.enable = false; # nixos documentation
      man.enable = true; # manual pages and the man command
      info.enable = false; # info pages and the info command
      doc.enable = false; # documentation distributed in packages' /share/doc
    };
  };
}
