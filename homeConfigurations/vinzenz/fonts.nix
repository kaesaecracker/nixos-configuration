{ pkgs, ... }:
{
  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = [ "FiraCode Nerd Font Mono" ];
  };
  home.packages = with pkgs; [
    nerd-fonts.fira-code
    roboto-mono
    recursive
  ];
}
