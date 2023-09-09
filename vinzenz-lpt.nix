{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./modules
    ./hardware/vinzenz-lpt.nix
  ];

  config = {
    networking.hostName = "vinzenz-lpt";

    my.gnome.enable = true;
    my.home.vinzenz.enable = true;

    services.flatpak.enable = true;
  };
}
