{...}: {
  config = {
    my.hardware = {
      enableCommonDesktopSettings = true;
      intel = {
        cpu = true;
        xe = true;
      };
    };

    boot.initrd = {
      availableKernelModules = ["xhci_pci" "thunderbolt" "nvme"];
      luks.devices = {
        "luks-2c654ff2-3c42-48d3-a1e3-9545679afaa3" = {
          device = "/dev/disk/by-uuid/2c654ff2-3c42-48d3-a1e3-9545679afaa3";
        };
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/e4dad0c8-26a1-45e9-bbd9-48565eb6574e";
        fsType = "btrfs";
        options = ["subvol=@"];
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/E2B7-2BC1";
        fsType = "vfat";
      };
    };

    swapDevices = [];
  };
}
