{ pkgs, lib, ... }:
{
  config.programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${lib.getBin pkgs.gnome-console}/bin/kgx";
        icon-theme = "Adwaita";
        counter = true;
        launch-prefix = "niri msg action spawn --";
      };
      border = {
        radius = 30;
        width = 3;
      };
    };
  };
}
