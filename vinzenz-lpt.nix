{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./my/default.nix];

  config = {
    networking.hostName = "vinzenz-lpt";

    my.gnome.enable = true;
    my.home.vinzenz.enable = true;

    services.flatpak.enable = true;

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

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.enableRedistributableFirmware = true;
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
