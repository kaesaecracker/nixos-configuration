{
  config,
  pkgs,
  lib,
  ...
}: let
  isUserEnabled = builtins.elem "ronja" config.my.enabledUsers;
in {
  config = lib.mkMerge [
    (lib.mkIf isUserEnabled {
      # Define user account
      users.users.ronja = {
        isNormalUser = true;
        name = "ronja";
        description = "Ronja Spiegelberg";
        home = "/home/ronja";
        extraGroups = ["networkmanager" "wheel" "games"];
        shell = pkgs.zsh;
      };
    })
    (lib.mkIf (isUserEnabled && config.my.modulesCfg.enableHomeManager) {
      home-manager.users.ronja = import ./ronja-home.nix;
    })
  ];
}
