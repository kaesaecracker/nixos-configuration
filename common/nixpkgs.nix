{
  config,
  lib,
  ...
}: {
  options.my.allowUnfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    example = ["steam"];
  };
  config = {
    nixpkgs.config = {
      # https://github.com/NixOS/nixpkgs/issues/197325#issuecomment-1579420085
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.my.allowUnfreePackages;
    };

    nix = {
      settings = {
        substituters = ["https://nix-community.cachix.org" "https://cache.nixos.org/"];
        trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
      };
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };
    };

    system = {
      stateVersion = "22.11";
      # enable auto updates
      autoUpgrade = {
        enable = true;
        dates = "weekly";
      };
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
