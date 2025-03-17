{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  config = {
    nixpkgs = {
      hostPlatform = "aarch64-linux";
      system = "aarch64-linux";
    };

    boot = {
      tmp.cleanOnBoot = true;
      kernelParams = [ "console=tty" ];
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "virtio_scsi"
          "sr_mod"
          "virtio_gpu"
        ];
        kernelModules = [ ];
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/47bc77ff-12e1-4d39-bb5c-fb100ccd3aab";
        fsType = "ext4";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/05F2-8F9A";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/bbd18a70-b0bb-4e1a-b45b-3c1f8ecc0c10"; }
    ];

    networking.useNetworkd = true;
    systemd.network = {
      enable = true;
      networks."10-wan" = {
        matchConfig.Name = "enp1s0";
        networkConfig.DHCP = "ipv4";
        address = [
          "2a01:4f8:c013:a524::1/64"
        ];
        routes = [
          { Gateway = "fe80::1"; }
        ];
      };
    };
  };
}
