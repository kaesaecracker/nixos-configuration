{ pkgs, config, ... }:
{
  config = {
    boot.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware = {
      graphics.enable = true;
      amdgpu = {
        opencl.enable = true;
        amdvlk = {
          # TODO: this creates black borders around GNOME apps
          # enable = true;
          # support32Bit.enable = config.hardware.graphics.enable32Bit;
        };
      };
    };

    environment.systemPackages = with pkgs; [ nvtopPackages.amd ];
  };
}
