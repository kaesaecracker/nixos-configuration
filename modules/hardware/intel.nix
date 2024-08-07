{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.hardware.intel;
in {
  options.my.hardware.intel = {
    cpu = lib.mkEnableOption "intel cpu";
    iGpu = lib.mkEnableOption "intel integrated gpu";
    xe = lib.mkEnableOption "intel xe gpu";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.cpu {
      boot.kernelModules = ["kvm-intel"];
      hardware.cpu.intel.updateMicrocode = true;
    })
    (lib.mkIf (cfg.iGpu || cfg.xe) {
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
      environment.systemPackages = with pkgs; [
        nvtopPackages.intel
      ];
      my.allowUnfreePackages = ["intel-ocl"];
    })
  ];
}
