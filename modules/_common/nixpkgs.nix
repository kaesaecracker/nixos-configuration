{...}: {
  config = {
    nixpkgs.config.allowUnfree = true;

    system = {
      stateVersion = "22.11";
      # enable auto updates
      autoUpgrade.enable = true;
    };

    nix.gc = {
      automatic = true;
      dates = "00:30";
    };
  };
}
