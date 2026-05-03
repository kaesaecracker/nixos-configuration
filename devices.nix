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
    distributedBuilds = {
      isBuilder = true;
      speedFactor = 1;
      clientPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK0NLgg0sFobBWz/bjYs9WkrMvlcvJC5F6+3jQ/b+AnD forgejo-runner-1-nix-builds";
      hostPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIANGC89GiT5xCsFICwrharrbV3q7acWHqk6ZwOUXbtGT";
      storeSigningPublicKey = "forgejo-runner-1:ln1FVLL8G5+IveQuBi/Kn3SaqFZ1gaiQrE3yPlMhCMA=";
    };
  };
  hetzner-vpn2 = {
    system = "aarch64-linux";
  };
  muede-lpt2 = {
    system = "x86_64-linux";
    isDesktop = true;
    home-manager-users = {
      inherit (self.homeConfigurations) muede;
    };
    distributedBuilds = {
      isBuilder = true;
      speedFactor = 2;
      hostPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGKoZ68wwyVRmPB0SkvpJUyUMDWeFbC5Je9zukyEOh7";
      clientPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKAbojdhb3PfazSRmudvo381Y+zUFVLMa7AbWbfK/Zp2 muede-lpt2-nix-builds";
      storeSigningPublicKey = "muede-lpt2:3csut7FW6oZK/ztRLBRC80LSBfFE3qzl+aIYgOixB6U=";
    };
  };
  muede-pc2 = {
    system = "x86_64-linux";
    isDesktop = true;
    home-manager-users = {
      inherit (self.homeConfigurations) muede;
    };
    distributedBuilds = {
      isBuilder = true;
      speedFactor = 4;
      hostPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEQQS5XNoj62Oj85xQfIuLORwoBRwfqjvfBHHsiI+RH";
      clientPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHmnyhP6L+kGHV15cb/d31AQr50wSEaQhkUBwy2+OEKk muede-pc2-nix-builds";
      storeSigningPublicKey = "muede-pc2:fqQO0E0y65MjUWlQnrgWt5ZsmQKlKCv4jls3CmUXDEQ=";
    };
  };
  ronja-pc = {
    system = "x86_64-linux";
    isDesktop = true;
    home-manager-users = {
      inherit (self.homeConfigurations) ronja;
    };
  };
  # keep-sorted end
}
