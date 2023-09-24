{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    <home-manager/nixos>
  ];

  config = {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      # defaults for users
      sharedModules = import ./home-shared-modules.nix;

      users = {
        ronja = lib.mkIf (builtins.elem "ronja" config.my.enabledUsers) (import ./ronja-home.nix);
        vinzenz = lib.mkIf (builtins.elem "vinzenz" config.my.enabledUsers) (import ./vinzenz-home.nix);
      };
    };
  };
}
