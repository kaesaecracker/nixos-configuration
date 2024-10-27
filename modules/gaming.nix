{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
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
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
      };
      gamemode.enable = true;
    };

    networking.firewall = {
      allowedUDPPorts = [
        # Factorio
        34197

        # steam network transfer
        3478
      ];

      allowedTCPPorts = [
        # steam network transfer
        24070
      ];

      allowedTCPPortRanges = [
        # steam network transfer
        {
          from = 27015;
          to = 27050;
        }
      ];

      allowedUDPPortRanges = [
        # steam network transfer
        {
          from = 4379;
          to = 4380;
        }
        {
          from = 27000;
          to = 27100;
        }
      ];
    };

    allowedUnfreePackages = [
      "steam"
      "steam-original"
      "steam-run"
    ];
  };
}
