{ pkgs, ... }:
{
  services.swaync = {
    enable = true;
    settings = {
      "$schema" = "${pkgs.swaynotificationcenter}/etc/xdg/swaync/configSchema.json";

      hide-on-clear = true;

      positionX = "center";
      fit-to-screen = false;
      control-center-height = 750;

      widgets = [
        "mpris"
        "volume"
        "title"
        "dnd"
        "inhibitors"
        "notifications"
      ];

      widget-config = {
        mpris.autohide = true;
      };
    };
  };
}
