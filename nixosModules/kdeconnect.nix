{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      networking.firewall =
        let
          kdeconnect-range = {
            from = 1714;
            to = 1764;
          };
        in
        {
          allowedTCPPortRanges = [ kdeconnect-range ];
          allowedUDPPortRanges = [ kdeconnect-range ];
        };

      programs.kdeconnect.enable = true;
      home-manager.sharedModules = [
        {
          services.kdeconnect = {
            enable = true;
            # this still shows up in gnome session starting with 25.05
            # indicator = true;
          };
        }
      ];
    }

    (lib.mkIf config.services.desktopManager.gnome.enable {
      # replace kdeconnect with gsconnect
      programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;

      home-manager.sharedModules = [
        (
          { pkgs, ... }:
          {
            home.packages = [ pkgs.gnomeExtensions.gsconnect ];
            # enable gsconnect extension
            dconf.settings = {
              "org/gnome/shell".enabled-extensions = [ "gsconnect@andyholmes.github.io" ];
              "org/gnome/shell/extensions/gsconnect".enabled = true;
            };
          }
        )
      ];
    })
  ];
}
