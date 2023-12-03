{pkgs, ...}: {
  config = {
    environment = {
      pathsToLink = ["/share/zsh"];
      systemPackages = with pkgs; [
        pciutils
        ncdu
        tldr
        glances
      ];
    };

    programs = {
      zsh.enable = true;
      htop.enable = true;
      iotop.enable = true;
      nano = {
        enable = true;
        syntaxHighlight = true;
      };
      git = {
        enable = true;
        package = pkgs.gitFull;
      };
    };
  };
}
