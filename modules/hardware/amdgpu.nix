{
  lib,
  config,
  pkgs,
  ...
}: let
  isEnabled = config.my.hardware.isAmdGpu;
in {
  options.my.hardware.isAmdGpu = lib.mkEnableOption "amd gpu";

  config = lib.mkIf isEnabled {
    environment.systemPackages = with pkgs; [
      radeontop
    ];
  };
}
