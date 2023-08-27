# nixos-configuration

When adding a new host:
1. install NixOS via the graphical installer
2. `mv /etc/hardware-configuration ./devicename-hardware-configuration.nix`
3. copy an existing devicename.nix
5. change import to `new-devicename-hardware-configuration.nix`
6. set the hostname and optional imports in `new-devicename.nix`
7. `ln -s ./new-devicename.nix /etc/nixos/configuration.nix`
8. `sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager`
9. apply
