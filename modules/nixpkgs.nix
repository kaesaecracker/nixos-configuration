{
  config,
  lib,
  ...
}: let
  unstable-commit-sha = "e92b6015881907e698782c77641aa49298330223";
  ultrastable-commit-sha = "5de0b32be6e85dc1a9404c75131316e4ffbc634c";
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
      dates = "monthly";
      options = "--delete-older-than 30d";
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
