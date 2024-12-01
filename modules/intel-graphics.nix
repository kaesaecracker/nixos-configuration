{ config, pkgs, ... }:
{
  config = {
    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        intel-ocl
        intel-compute-runtime
        vpl-gpu-rt
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        intel-vaapi-driver
        intel-media-driver
      ];
    };
    environment.systemPackages = with pkgs; [ nvtopPackages.intel ];
    allowedUnfreePackages = [ "intel-ocl" ];
  };
}
