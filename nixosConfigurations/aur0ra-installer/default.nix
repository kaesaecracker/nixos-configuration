{
  nixos-images,
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    ../aur0ra
   # nixos-images.nixosModules.sdimage-installer
  ];
  disabledModules = [
    # disable the sd-image module that nixos-images uses
   # (modulesPath + "/installer/sd-card/sd-image-aarch64-installer.nix")
  ];
}
