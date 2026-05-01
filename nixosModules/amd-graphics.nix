{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.my.amdGraphics.enable = lib.mkEnableOption "AMD graphics drivers";

  config = lib.mkIf config.my.amdGraphics.enable {
    boot.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware = {
      graphics.enable = true;
      amdgpu = {
        opencl.enable = true;
        overdrive.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [ nvtopPackages.amd ];
  };
}
