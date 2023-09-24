{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      pciutils
      ncdu
      htop
      tldr
    ];
  };
}
