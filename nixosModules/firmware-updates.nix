{ lib, config, ... }:
{
  options.my.firmwareUpdates.enable = lib.mkEnableOption "firmware updates and microcode";

  config = lib.mkIf config.my.firmwareUpdates.enable {
    hardware = {
      enableRedistributableFirmware = true;
      cpu = {
        amd.updateMicrocode = true;
        intel.updateMicrocode = true;
      };
    };

    services.fwupd.enable = true;
  };
}
