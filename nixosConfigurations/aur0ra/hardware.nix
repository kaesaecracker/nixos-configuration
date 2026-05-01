{ nixos-raspberrypi, lib, ... }:
{
  imports = with nixos-raspberrypi.nixosModules; [
    raspberry-pi-5.base
    raspberry-pi-5.bluetooth
    raspberry-pi-5.page-size-16k
    raspberry-pi-5.display-vc4
  ];

  # No one got time for xz compression.
  #isoImage.squashfsCompression = "zstd";

  boot.loader.raspberry-pi.bootloader = "kernel";

  my.systemdBoot.enable = lib.mkForce false;

  /*
    fileSystems = {
      "/boot/firmware" = {
        # TODO
        device = "/dev/disk/by-uuid/2175-794E";
        fsType = "vfat";
        options = [
          "noatime"
          "noauto"
          "x-systemd.automount"
          "x-systemd.idle-timeout=1min"
        ];
      };
      "/" = {
        # TODO
        device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
        fsType = "ext4";
        options = [ "noatime" ];
      };
    };
  */

  hardware.raspberry-pi.config = {
    all = {
      # [all] conditional filter, https://www.raspberrypi.com/documentation/computers/config_txt.html#conditional-filters
      # Base DTB parameters
      # https://github.com/raspberrypi/linux/blob/a1d3defcca200077e1e382fe049ca613d16efd2b/arch/arm/boot/dts/overlays/README#L132
      base-dt-params = {

        # https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#enable-pcie
        pciex1 = {
          enable = true;
          value = "on";
        };
        # PCIe Gen 3.0
        # https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#pcie-gen-3-0
        pciex1_gen = {
          enable = true;
          value = "3";
        };

      };

    };
  };
}
