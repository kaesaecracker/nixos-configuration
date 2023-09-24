{
  config,
  pkgs,
  lib,
  ...
}: let
  isEnabled = config.my.desktop.enableGaming;
in {
  imports = [];

  options.my.desktop.enableGaming = lib.mkEnableOption "gaming with wine";

  config = lib.mkIf isEnabled {
    hardware.opengl.driSupport32Bit = true;

    environment.systemPackages = with pkgs; [
      wineWowPackages.stagingFull
      wineWowPackages.fonts
      winetricks
      steam

      (lutris.override {
        extraPkgs = pkgs: [
          # List package dependencies here
        ];
        extraLibraries = pkgs: [
          # List library dependencies here
        ];
      })
    ];
  };
}
