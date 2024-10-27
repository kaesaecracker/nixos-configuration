{lib, ...}: {
  imports = [
    ../../modules/intel-graphics.nix
  ];
  config = {
    # intel cpu
    boot.kernelModules = ["kvm-intel"];
    hardware.cpu.intel.updateMicrocode = true;

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;

    hardware.enableRedistributableFirmware = true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

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

    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 32 * 1024;
      }
    ];

    services.thermald.enable = true;
    services.hardware.bolt.enable = true; # thunderbolt security
  };
}
