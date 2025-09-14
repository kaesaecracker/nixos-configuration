{ pkgs, ... }:
{
  config = {
    hardware = {
      graphics = {
        enable32Bit = true;
        extraPackages = with pkgs; [ mangohud ];
        extraPackages32 = with pkgs; [ mangohud ];
      };

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

    networking.firewall.allowedUDPPorts = [
      # Factorio
      34197
    ];
  };
}
