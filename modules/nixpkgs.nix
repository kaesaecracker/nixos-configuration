{
  config,
  lib,
  ...
}: let
  unstable-commit-sha = "f5892ddac112a1e9b3612c39af1b72987ee5783a";
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
      };

      # https://github.com/NixOS/nixpkgs/issues/197325#issuecomment-1579420085
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.my.allowUnfreePackages;
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
