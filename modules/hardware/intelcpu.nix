{
  lib,
  config,
  ...
}: let
  isEnabled = config.my.hardware.isIntelCpu;
in {
  options.my.hardware.isIntelCpu = lib.mkEnableOption "intel cpu";

  config = lib.mkIf isEnabled {
    boot.kernelModules = ["kvm-intel"];
    hardware.cpu.intel.updateMicrocode = true;
  };
}
