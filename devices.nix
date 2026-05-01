{ self }:
let
  nixos-raspberrypi = self.inputs.nixos-raspberrypi;
in
{
  # keep-sorted start block=yes
  aur0ra = {
    system = "aarch64-linux";
    nixosSystem = nixos-raspberrypi.lib.nixosSystem;
  };
  aur0ra-installer = {
    # build with nix build .\#nixosConfigurations.aur0ra-installer.config.system.build.sdImage
    system = "aarch64-linux";
    nixosSystem = nixos-raspberrypi.lib.nixosInstaller;
  };
  damocles = {
    system = "x86_64-linux";
    distributedBuilds.maxJobs = 0;
  };
  damocles-lab = {
    system = "x86_64-linux";
    distributedBuilds.maxJobs = 0;
  };
  epimetheus = {
    system = "aarch64-linux";
  };
  forgejo-runner-1 = {
    system = "aarch64-linux";
  };
  hetzner-vpn2 = {
    system = "aarch64-linux";
  };
  muede-lpt2 = {
    system = "x86_64-linux";
    home-manager-users = {
      inherit (self.homeConfigurations) muede;
    };
    distributedBuilds = {
      isBuilder = true;
      hostPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGKoZ68wwyVRmPB0SkvpJUyUMDWeFbC5Je9zukyEOh7";
      clientPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKAbojdhb3PfazSRmudvo381Y+zUFVLMa7AbWbfK/Zp2 muede-lpt2-nix-builds";
    };
  };
  muede-pc2 = {
    system = "x86_64-linux";
    home-manager-users = {
      inherit (self.homeConfigurations) muede;
    };
    distributedBuilds = {
      isBuilder = true;
      speedFactor = 2;
      hostPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEQQS5XNoj62Oj85xQfIuLORwoBRwfqjvfBHHsiI+RH";
      clientPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHmnyhP6L+kGHV15cb/d31AQr50wSEaQhkUBwy2+OEKk muede-pc2-nix-builds";
    };
  };
  ronja-pc = {
    system = "x86_64-linux";
    home-manager-users = {
      inherit (self.homeConfigurations) ronja;
    };
  };
  # keep-sorted end
}
