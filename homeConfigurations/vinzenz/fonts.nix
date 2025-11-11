{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    roboto-mono
    recursive
    font-awesome
  ];
}
