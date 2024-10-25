{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
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
