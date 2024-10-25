{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  config = {
    nixpkgs = {
      hostPlatform = "aarch64-linux";
      system = "aarch64-linux";
    };

    boot = {
      tmp.cleanOnBoot = true;
      loader = {
        systemd-boot.enable = lib.mkForce false;
        efi.canTouchEfiVariables = lib.mkForce false;
        grub = {
          enable = true;
          efiSupport = true;
          efiInstallAsRemovable = true;
          device = "nodev";
        };
      };
      initrd = {
        availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront"];
        kernelModules = ["nvme"];
      };
    };

    zramSwap.enable = true;
    networking.domain = "";

    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-uuid/77CF-345D";
        fsType = "vfat";
      };
      "/" = {
        device = "/dev/sda1";
        fsType = "ext4";
      };
    };

    # This file was populated at runtime with the networking
    # details gathered from the active system.
    networking = {
      nameservers = ["8.8.8.8"];
      defaultGateway = "172.31.1.1";
      defaultGateway6 = {
        address = "fe80::1";
        interface = "eth0";
      };
      dhcpcd.enable = false;
      usePredictableInterfaceNames = lib.mkForce false;
      interfaces = {
        eth0 = {
          ipv4 = {
            addresses = [
              {
                address = "157.90.146.125";
                prefixLength = 32;
              }
            ];
            routes = [
              {
                address = "172.31.1.1";
                prefixLength = 32;
              }
            ];
          };
          ipv6 = {
            addresses = [
              {
                address = "2a01:4f8:c012:7137::1";
                prefixLength = 64;
              }
              {
                address = "fe80::9400:2ff:fe87:7fc9";
                prefixLength = 64;
              }
            ];
            routes = [
              {
                address = "fe80::1";
                prefixLength = 128;
              }
            ];
          };
        };
      };
    };

    services.udev.extraRules = ''
      ATTR{address}=="96:00:02:87:7f:c9", NAME="eth0"

    '';
  };
}
