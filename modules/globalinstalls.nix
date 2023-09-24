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
      zsh.enable = true;
      htop.enable = true;
      iotop.enable = true;
      nano.syntaxHighlight = true;
      git = {
        enable = true;
        package = pkgs.gitFull;
      };
    };
  };
}
