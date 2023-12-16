{pkgs, ...}: {
  config = {
    environment = {
      pathsToLink = ["/share/zsh"];
      systemPackages = with pkgs; [
        ncdu
        glances
        iotop

        pciutils
        lsof
        dig

        screen

        tldr

        icu
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
