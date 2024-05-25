{
  config,
  pkgs,
  lib,
  ...
}: let
  isUserEnabled = builtins.elem "ronja" config.my.enabledUsers;
in {
  config = lib.mkIf isUserEnabled {
    # Define user account
    users.users.ronja = {
      isNormalUser = true;
      name = "ronja";
      description = "Ronja";
      home = "/home/ronja";
      extraGroups = ["networkmanager" "wheel" "games" "podman"];
      shell = pkgs.zsh;
    };
  };
}
