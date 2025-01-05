{
  nixpkgs,
  common-modules,
  desktop-modules,
  nixos-hardware,
  home-manager,
  ...
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = common-modules ++ [
    home-manager.nixosModules.home-manager
    ../../home
    ../../modules/desktop-environment.nix

    nixos-hardware.nixosModules.apple-macbook-pro-14-1
    { allowedUnfreePackages = [ "b43-firmware" ]; }

    ./hardware.nix
    ../../home/gnome.nix
    ../../users/ronja.nix
    ../../modules/gnome.nix

    {
      networking = {
        hostName = "ona-book";
        networkmanager.enable = true;
      };
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
