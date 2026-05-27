{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  config = {
    my.hetznerVm = {
      enable = true;
      rootUuid = "47bc77ff-12e1-4d39-bb5c-fb100ccd3aab";
      bootUuid = "05F2-8F9A";
      swapUuid = "bbd18a70-b0bb-4e1a-b45b-3c1f8ecc0c10";
      ipv6Address = "2a01:4f8:c013:a524::1/64";
    };
  };
}
