{
  config,
  lib,
  ...
}: let
  unstable-commit-sha = "9df3e30ce24fd28c7b3e2de0d986769db5d6225d";
  ultrastable-commit-sha = "2be119add7b37dc535da2dd4cba68e2cf8d1517e";
in {
  options.my.allowUnfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    example = ["steam"];
  };

  config = {
    nixpkgs.config = {
      # make nixos-unstable availiable as 'pkgs.unstable'
      packageOverrides = pkgs: {
        unstable = import (fetchTarball "https://github.com/nixos/nixpkgs/tarball/${unstable-commit-sha}") {
          config = config.nixpkgs.config;
        };
        ultrastable = import (fetchTarball "https://github.com/nixos/nixpkgs/tarball/${ultrastable-commit-sha}") {
          config = config.nixpkgs.config;
        };
      };

      # https://github.com/NixOS/nixpkgs/issues/197325#issuecomment-1579420085
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.my.allowUnfreePackages;
    };

    nix = {
      settings = {
        substituters = ["https://nix-community.cachix.org" "https://cache.nixos.org/"];
        trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
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

    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
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
