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

      (lutris.override {
        extraPkgs = pkgs: [
          # List package dependencies here
        ];
        extraLibraries = pkgs: [
          # List library dependencies here
        ];
      })
    ];

    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      };
    };
  };
}
