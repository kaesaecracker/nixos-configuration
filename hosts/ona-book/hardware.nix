{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/hardware/network/broadcom-43xx.nix")
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = {
    boot = {
      initrd.availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      initrd.kernelModules = [ ];
      kernelModules = [
        "kvm-intel"
        "snd_hda_codec_cs8409"
        "hci_uart"
        "bluetooth"
        "btbcm"
      ];
      extraModulePackages = [ ];
      blacklistedKernelModules = [ ];
      kernelParams = [];
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          editor = false; # do not allow changing kernel parameters
          consoleMode = "max";
        };
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/15220182-5617-4963-814e-19ff29b7db8c";
        fsType = "btrfs";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/1C7D-07C1";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/e4c91c7e-8b62-48e4-923d-4d750ebbc7db"; }
    ];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    hardware.enableAllFirmware = true;
    nixpkgs.config.allowUnfree = true;
    hardware.enableRedistributableFirmware = true;

    hardware.facetimehd.enable = true;
  };
}
