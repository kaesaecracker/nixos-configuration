{ lib, config, ... }:
{
  options.my.autoupdate.enable = lib.mkEnableOption "automatic Nix GC and system upgrades";

  config = lib.mkIf config.my.autoupdate.enable {
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
      # do not forget to set `flake` when using this module!
    };
  };
}
