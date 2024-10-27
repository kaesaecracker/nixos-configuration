{ config, pkgs, ... }:
{
  config = {
    hardware.opengl = {
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-ocl
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    environment.systemPackages = with pkgs; [ nvtopPackages.intel ];
    allowedUnfreePackages = [ "intel-ocl" ];
  };
}
