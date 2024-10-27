{...}: {
  imports = [
    ../../modules/amd-graphics.nix
  ];
  config = {
    # amd cpu
    boot.kernelModules = ["kvm-amd"];
    hardware.cpu.amd.updateMicrocode = true;

    boot = {
      initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"]; # "usb_storage"
      loader.efi.efiSysMountPoint = "/boot";
    };

    fileSystems = import ./fstab.nix;
    swapDevices = [];

    networking.interfaces.eno1.wakeOnLan.enable = true;
  };
}
