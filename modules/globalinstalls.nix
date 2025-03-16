{ pkgs, ... }:
{
  config = {
    environment = {
      systemPackages = with pkgs; [
        ncdu
        glances
        iotop

        pciutils
        lsof
        dig

        screen

        tldr
        neofetch
      ];
    };

    programs = {
      zsh.enable = true;
      htop.enable = true;
      iotop.enable = true;
      git.enable = true;
      nano = {
        enable = true;
        syntaxHighlight = true;
      };
    };
  };
}
