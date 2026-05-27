{
  lib,
  config,
  ...
}:
let
  cfg = config.my.hetznerVm;
in
{
  options.my.hetznerVm = {
    enable = lib.mkEnableOption "Hetzner Cloud aarch64 qemu-guest defaults";

    rootUuid = lib.mkOption {
      type = lib.types.str;
      description = "UUID of the root ext4 filesystem.";
    };
    bootUuid = lib.mkOption {
      type = lib.types.str;
      description = "UUID of the FAT /boot partition.";
    };
    swapUuid = lib.mkOption {
      type = lib.types.str;
      description = "UUID of the swap device.";
    };
    ipv6Address = lib.mkOption {
      type = lib.types.str;
      description = "Static IPv6 address (with /prefix) assigned to enp1s0.";
      example = "2a01:4f8:c013:cbdd::1/64";
    };
  };

  config = lib.mkIf cfg.enable {
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
        device = "/dev/disk/by-uuid/${cfg.rootUuid}";
        fsType = "ext4";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/${cfg.bootUuid}";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/${cfg.swapUuid}"; }
    ];

    networking.useNetworkd = true;
    systemd.network = {
      enable = true;
      networks."10-wan" = {
        matchConfig.Name = "enp1s0";
        networkConfig.DHCP = "ipv4";
        address = [ cfg.ipv6Address ];
        routes = [
          { Gateway = "fe80::1"; }
        ];
      };
    };

    services.tailscale.useRoutingFeatures = "both";
    system.autoUpgrade.allowReboot = true;
  };
}
