{ config, ... }:
{
  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = import ./shared-modules.nix;
    };
  };
}
