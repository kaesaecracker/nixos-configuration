{
  config,
  pkgs,
  lib,
  ...
}: let
  isUserEnabled = builtins.elem "vinzenz" config.my.enabledUsers;
in {
  config = lib.mkMerge [
    (lib.mkIf isUserEnabled {
      users.users.vinzenz = {
        isNormalUser = true;
        name = "vinzenz";
        description = "Vinzenz Schroeter";
        home = "/home/vinzenz";
        extraGroups = ["networkmanager" "wheel" "games"];
        shell = pkgs.zsh;
      };
    })
    (lib.mkIf (isUserEnabled && config.my.modulesCfg.enableHomeManager) {
      home-manager.users.vinzenz = import ./vinzenz-home.nix;
    })
  ];
}
