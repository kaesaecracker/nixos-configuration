{
  modulesPath,
  lib,
  config,
  ...
}:
{
  # Import unconditionally — the module only defines options, activating nothing by default.
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];

  options.my.pxvirtGuest.enable = lib.mkEnableOption "Proxmox LXC guest configuration";

  config = lib.mkIf config.my.pxvirtGuest.enable {
    # TODO is this needed?
    # nix.settings.sandbox = false;

    proxmoxLXC = {
      manageNetwork = false;
      privileged = false;
    };

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
