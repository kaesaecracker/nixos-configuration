{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  config = {
    nixpkgs = {
      hostPlatform = "aarch64-linux";
      system = "aarch64-linux";
    };

    boot = {
      tmp.cleanOnBoot = true;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "virtio_scsi"
          "sr_mod"
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

    # This file was populated at runtime with the networking
    # details gathered from the active system.
    networking = {
      useDHCP = true;
      domain = "";
      nameservers = [ "8.8.8.8" ];
      defaultGateway6 = {
        address = "fe80::1";
        interface = "enp1s0";
      };
      interfaces = {
        enp1s0 = {
          #ipv4 = {
          #  addresses = [
          #    {
          #      address = "157.90.146.125";
          #      prefixLength = 32;
          #    }
          #  ];
          #  routes = [
          #    {
          #      address = "172.31.1.1";
          #      prefixLength = 32;
          #    }
          #  ];
          #};
          ipv6 = {
            addresses = [
              {
                address = "2a01:4f8:c013:65dd::";
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

    #services.udev.extraRules = ''
    #  ATTR{address}=="96:00:02:87:7f:c9", NAME="eth0"
    #'';
  };
}
