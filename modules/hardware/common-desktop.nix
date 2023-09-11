{lib, ...}: {
  config = {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

    hardware.enableRedistributableFirmware = true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
