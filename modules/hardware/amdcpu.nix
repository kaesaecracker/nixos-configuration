{
  lib,
  config,
  pkgs,
  ...
}: let
  isEnabled = config.my.hardware.isAmdCpu;
in {
  options.my.hardware.isAmdCpu = lib.mkEnableOption "amd cpu";

  config = lib.mkIf isEnabled {
    boot.kernelModules = ["kvm-amd"];
    hardware.cpu.amd.updateMicrocode = true;
  };
}
