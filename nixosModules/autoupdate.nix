{
  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };

  system.autoUpgrade = {
    enable = true;
    dates = "daily";
  };
}
