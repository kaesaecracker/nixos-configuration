{ pkgs, ... }:
{
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
}
