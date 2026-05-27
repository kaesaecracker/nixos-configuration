{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  config = {
    my.hetznerVm = {
      enable = true;
      rootUuid = "3263489d-9819-433c-b198-9d2e732a94e4";
      bootUuid = "6C25-6BDC";
      swapUuid = "e147721d-86b5-40d7-a231-c6ea391c563d";
      ipv6Address = "2a01:4f8:c013:65dd::1/64";
    };
  };
}
