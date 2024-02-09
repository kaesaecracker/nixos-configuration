{
  config,
  pkgs,
  lib,
  ...
}: let
  isUserEnabled = builtins.elem "vinzenz" config.my.enabledUsers;
in {
  config = lib.mkIf isUserEnabled {
    users.users.vinzenz = {
      isNormalUser = true;
      name = "vinzenz";
      description = "Vinzenz Schroeter";
      home = "/home/vinzenz";
      extraGroups = ["networkmanager" "wheel" "games" "dialout" "podman"];
      shell = pkgs.zsh;
    };
  };
}
