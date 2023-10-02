{config, ...}: let
  unstable-commit-sha = "f5892ddac112a1e9b3612c39af1b72987ee5783a";
in {
  config = {
    nixpkgs.config = {
      allowUnfree = true;

      # make nixos-unstable availiable as 'pkgs.unstable'
      packageOverrides = pkgs: {
        unstable = import (fetchTarball "https://github.com/nixos/nixpkgs/tarball/${unstable-commit-sha}") {
          config = config.nixpkgs.config;
        };
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
  };
}
