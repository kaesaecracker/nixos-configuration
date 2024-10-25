{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.hardware.amd;
in {
  options.my.hardware.amd = {
    cpu = lib.mkEnableOption "amd cpu";
    gpu = lib.mkEnableOption "amd gpu";
    radeon = lib.mkEnableOption "amd legacy gpu"; # old hardware, dont judge
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.cpu {
      boot.kernelModules = ["kvm-amd"];
      hardware.cpu.amd.updateMicrocode = true;
    })

    (lib.mkIf cfg.gpu {
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
    })

    (lib.mkIf cfg.radeon {
      boot.kernelModules = ["radeon"];
      services.xserver.videoDrivers = ["radeon"];
      environment.systemPackages = with pkgs; [
        radeontop
      ];
    })
  ];
}
