{
  lib,
  config,
  pkgs,
  ...
}: let
  isEnabled = config.my.desktop.enableGnome;
in {
  config = lib.mkIf isEnabled {
    home-manager.sharedModules = [
      {
        home.packages = with pkgs; [
          amberol
        ];
        dconf.settings = {
          "org/gnome/desktop/peripherals/keyboard" = {
            numlock-state = true;
          };
        };
      }
    ];
  };
}
