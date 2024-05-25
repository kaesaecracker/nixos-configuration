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
      description = "Vinzenz";
      home = "/home/vinzenz";
      extraGroups = ["networkmanager" "wheel" "games" "dialout" "podman" "nginx"];
      shell = pkgs.zsh;
      autoSubUidGidRange = true;
    };
  };
}
