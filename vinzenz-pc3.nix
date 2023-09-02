{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.hostName = "vinzenz-pc3";

  imports = [
    ./common.nix
    ./kde.nix
    ./home-vinzenz.nix
    ./home-ronja.nix
  ];

  users.users.vinzenz.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrY6tcgnoC/xbgL7vxSjddEY9MBxRXe9n2cAHt88/TT home roaming"
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

    "/mnt/manjaro" = {
      device = "/dev/disk/by-uuid/b6b4c0b8-4b16-4a72-a18d-d7923a2bb532";
      fsType = "btrfs";
      options = ["subvol=@"];
    };

    "/mnt/manjaro/home" = {
      device = "/dev/disk/by-uuid/b6b4c0b8-4b16-4a72-a18d-d7923a2bb532";
      fsType = "btrfs";
      options = ["subvol=@home"];
    };

    "/mnt/ssd2" = {
      device = "/dev/disk/by-uuid/6b2a647d-c68e-4c07-85bf-c9bfc5db7e8a";
      fsType = "ext4";
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
