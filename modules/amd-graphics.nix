{
  lib,
  config,
  pkgs,
  ...
}: {
  config = {
    boot.kernelModules = ["amdgpu"];
    services.xserver.videoDrivers = ["amdgpu"];

    hardware.opengl = {
      extraPackages = with pkgs; [
        amdvlk
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };

    environment.systemPackages = with pkgs; [
      nvtopPackages.amd
    ];
  };
}
