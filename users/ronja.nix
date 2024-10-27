{ pkgs, ... }:
{
  config = {
    # Define user account
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
      ];
      shell = pkgs.zsh;
    };
  };
}
