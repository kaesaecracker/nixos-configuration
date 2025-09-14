{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  config = {
    boot = {
      tmp.cleanOnBoot = true;
      kernelParams = [ "console=tty" ];
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "virtio_scsi"
          "sr_mod"
          "virtio_gpu"
        ];
        kernelModules = [ ];
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/3263489d-9819-433c-b198-9d2e732a94e4";
        fsType = "ext4";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/6C25-6BDC";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/e147721d-86b5-40d7-a231-c6ea391c563d"; }
    ];

    networking.useNetworkd = true;
    systemd.network = {
      enable = true;
      networks."10-wan" = {
        matchConfig.Name = "enp1s0";
        networkConfig.DHCP = "ipv4";
        address = [
          "2a01:4f8:c013:65dd::1/64"
        ];
        routes = [
          { Gateway = "fe80::1"; }
        ];
      };
    };
  };
}
