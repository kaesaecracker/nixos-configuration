{...}: {
  imports = [
    ./common-desktop.nix
  ];

  config = {
    boot = {
      initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"]; # "usb_storage"
      initrd.kernelModules = [];
      kernelModules = ["kvm-amd"];
      extraModulePackages = [];
      loader.efi.efiSysMountPoint = "/boot";
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/0e9c983a-e733-447e-8181-f41d6670c4b8";
        fsType = "btrfs";
        options = ["subvol=@"];
      };

      "/home" = {
        device = "/dev/disk/by-uuid/0e9c983a-e733-447e-8181-f41d6670c4b8";
        fsType = "btrfs";
        options = ["subvol=@home"];
      };

      "/games" = {
        device = "/dev/disk/by-uuid/0e9c983a-e733-447e-8181-f41d6670c4b8";
        fsType = "btrfs";
        options = ["subvol=@games"];
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/AF67-8F16";
        fsType = "vfat";
      };

      "/mnt/nixos_btrfs_root" = {
        # subvolume with id 5 is always the root volume
        # this is convenient for managing the flat subvolume hierarchy
        device = "/dev/disk/by-uuid/0e9c983a-e733-447e-8181-f41d6670c4b8";
        fsType = "btrfs";
        options = ["subvolid=5"];
      };

      "/mnt/ssd2" = {
        device = "/dev/disk/by-uuid/6b2a647d-c68e-4c07-85bf-c9bfc5db7e8a";
        fsType = "ext4";
      };
    };

    swapDevices = [];

    hardware.cpu.amd.updateMicrocode = true;
  };
}
