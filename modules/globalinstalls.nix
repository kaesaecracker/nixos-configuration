{pkgs, ...}: {
  config = {
    environment = {
      pathsToLink = ["/share/zsh"];
      systemPackages = with pkgs; [
        pciutils
        ncdu
        tldr
      ];
    };

    programs = {
      git.enable = true;
      zsh.enable = true;
      htop.enable = true;
    };
  };
}
