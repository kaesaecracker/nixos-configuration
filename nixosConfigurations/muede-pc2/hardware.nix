{ pkgs, lib, ... }:
{
  # amd cpu
  boot.kernelModules = [ "kvm-amd" ];

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "sd_mod"
    ]; # "usb_storage"
    kernelPackages = pkgs.linuxPackages_zen;
    supportedFilesystems = [ "btrfs" ];
    initrd.supportedFilesystems = [ "btrfs" ];
    loader.efi.efiSysMountPoint = "/boot";
  };

  fileSystems = import ./fstab.nix;
  swapDevices = [ ];

  networking = {
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    interfaces.eno1.wakeOnLan.enable = true;
  };

  hardware.bluetooth.enable = true;
}
