{
  config,
  pkgs,
  lib,
  ...
}: let
  isEnabled = config.my.desktop.enableGaming;
in {
  options.my.desktop.enableGaming = lib.mkEnableOption "gaming with wine";

  config = lib.mkIf isEnabled {
    hardware = {
      opengl = {
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [mangohud];
        extraPackages32 = with pkgs; [mangohud];
      };

      steam-hardware.enable = true;
      xpadneo.enable = true;
    };

    environment.systemPackages = with pkgs; [
      wineWowPackages.stagingFull
      wineWowPackages.fonts
      winetricks
      dxvk
      mangohud
      vulkan-tools
      glxinfo
      lutris
    ];

    programs = {
      xwayland.enable = true;
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };
      gamemode.enable = true;
    };

    networking.firewall.allowedUDPPorts = [
      # Factorio
      34197
    ];

    my.allowUnfreePackages = [
      "steam"
      "steam-original"
      "steam-run"
    ];
  };
}
