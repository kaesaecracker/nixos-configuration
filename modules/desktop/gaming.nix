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
    hardware.opengl = {
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [mangohud];
      extraPackages32 = with pkgs; [mangohud];
    };

    environment.systemPackages = with pkgs; [
      wineWowPackages.stagingFull
      wineWowPackages.fonts
      winetricks
      dxvk
      mangohud
      vulkan-tools
      glxinfo

      (lutris.override {
        extraPkgs = pkgs: [
          # List package dependencies here
        ];
        extraLibraries = pkgs: [
          # List library dependencies here
        ];
      })
    ];

    hardware.steam-hardware.enable = true;

    programs = {
      xwayland.enable = true;
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };
    };

    networking.firewall.allowedUDPPortRanges = [
      {
        # Factorio
        from = 34197;
        to = 34197;
      }
    ];

    my.allowUnfreePackages = [
      "steam"
      "steam-original"
      "steam-run"
    ];
  };
}
