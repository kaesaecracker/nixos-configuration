{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  config = {
    my.hetznerVm = {
      enable = true;
      rootUuid = "73dfcfd2-3a61-4b05-8440-d57072b89eda";
      bootUuid = "E9C2-D85B";
      swapUuid = "737140f2-c2fd-4af9-9974-f05642f8d90e";
      ipv6Address = "2a01:4f8:c013:cbdd::1/64";
    };

    fileSystems."/var/lib/forgejo" = {
      device = "/dev/disk/by-uuid/da5efb9a-7dc2-4fa3-aeca-c9bf634054b0";
      fsType = "ext4";
      options = [ "discard" "nofail" "defaults" ];
    };
  };
}
