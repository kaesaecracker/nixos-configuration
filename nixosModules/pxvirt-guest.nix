{
  lib,
  config,
  ...
}:
{
  options.my.pxvirtGuest.enable = lib.mkEnableOption "Proxmox LXC guest configuration";

  config = lib.mkIf config.my.pxvirtGuest.enable {
    # Let Proxmox host handle fstrim
    services.fstrim.enable = false;

    # TODO is this needed
    # Cache DNS lookups to improve performance
    services.resolved.extraConfig = ''
      Cache=true
      CacheFromLocalhost=true
    '';

    boot.loader.systemd-boot.enable = lib.mkForce false;
  };
}
