{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];

  config = {
    my.pxvirtGuest.enable = true;

    proxmoxLXC = {
      manageNetwork = false;
      privileged = false;
    };
  };
}
