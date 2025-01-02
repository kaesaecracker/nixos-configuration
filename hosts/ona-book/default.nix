{
  nixpkgs,
  common-modules,
  desktop-modules,
  ...
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules =
    common-modules
    ++ desktop-modules
    ++ [
      ./hardware.nix
      ../../home/gnome.nix
      ../../users/ronja.nix
      ../../modules/gnome.nix

      {
        networking.hostName = "ona-book";
        services.xserver.xkb = {
          layout = "us";
          options = "eurosign:e,caps:escape";
        };
      }

      {
        home-manager.users.ronja = import ../../home/ronja;

        users.users.ronja.openssh.authorizedKeys.keys = [
        ];
      }

      {

      }
    ];
}
