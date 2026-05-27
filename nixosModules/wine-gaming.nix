{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.my.wineGaming.enable = lib.mkEnableOption "Wine gaming (DXVK, MangoHud, xpadneo)";

  config = lib.mkIf config.my.wineGaming.enable {
    hardware = {
      graphics = {
        enable32Bit = true;
        extraPackages = with pkgs; [ mangohud ];
        extraPackages32 = with pkgs; [ mangohud ];
      };

      xpadneo.enable = true;
    };

    environment.systemPackages = with pkgs; [
      wineWow64Packages.stagingFull
      wineWow64Packages.fonts
      winetricks
      dxvk
      mangohud
      vulkan-tools
      mesa-demos
    ];
  };
}
