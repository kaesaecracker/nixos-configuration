{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.my.users.ronja.enable = lib.mkEnableOption "ronja user account";

  config = lib.mkIf config.my.users.ronja.enable {
    users.users.ronja = {
      isNormalUser = true;
      name = "ronja";
      description = "Ronja";
      home = "/home/ronja";
      extraGroups = [
        "networkmanager"
        "wheel"
        "games"
        "podman"
        "openvscode-server"
      ];
      shell = pkgs.zsh;
    };

    nix.settings.trusted-users = [ "ronja" ];
  };
}
