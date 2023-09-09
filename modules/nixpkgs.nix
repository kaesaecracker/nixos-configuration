{...}: {
  config = {
    nixpkgs.config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-12.2.3"
      ];
    };

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
