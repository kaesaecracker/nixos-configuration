{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.my.desktop.gaming;
in {
  imports = [];
  config = lib.mkIf cfg.enable {
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
