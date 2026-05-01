{ lib, config, ... }:
{
  options.my.systemdBoot.enable = lib.mkEnableOption "systemd-boot bootloader";

  config = lib.mkIf config.my.systemdBoot.enable {
    boot.loader = {
      timeout = 3;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false; # do not allow changing kernel parameters
        consoleMode = "max";
      };
    };
  };
}
