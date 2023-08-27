{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

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

    "/boot" = {
      device = "/dev/disk/by-uuid/AF67-8F16";
      fsType = "vfat";
    };

    "/sdmanjaro" = {
      device = "/dev/disk/by-uuid/b6b4c0b8-4b16-4a72-a18d-d7923a2bb532";
      fsType = "btrfs";
      options = ["subvol=@"];
    };

    "/sdmanjaro/home" = {
      device = "/dev/disk/by-uuid/b6b4c0b8-4b16-4a72-a18d-d7923a2bb532";
      fsType = "btrfs";
      options = ["subvol=home"];
    };
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
