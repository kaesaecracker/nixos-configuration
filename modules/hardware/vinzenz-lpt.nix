{...}: {
  imports = [
    ./common-desktop.nix
  ];

  config = {
    boot = {
      initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci"];
      initrd.kernelModules = [];
      kernelModules = ["kvm-intel"];
      extraModulePackages = [];
      loader.efi.efiSysMountPoint = "/boot/efi";
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/34cb86c4-8823-4785-9672-92ef0bcd5eaf";
        fsType = "btrfs";
        options = ["subvol=@"];
      };

      "/boot/efi" = {
        device = "/dev/disk/by-uuid/2381-1CD2";
        fsType = "vfat";
      };
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/f5932f70-60e4-4abe-b23d-2cab3c095c7d";}
    ];

    hardware.cpu.intel.updateMicrocode = true;
  };
}
