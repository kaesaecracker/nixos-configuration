{
  lib,
  config,
  ...
}: let
  isEnabled = config.my.desktop.enableKde;
in {
  config = lib.mkIf isEnabled {
    home-manager.sharedModules = [
      {
        services.kdeconnect = {
          enable = true;
          indicator = true;
        };
      }
    ];
  };
}
