{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ncdu
    glances
    lsof
    dig
    screen
    tldr
    nix-output-monitor
  ];

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
}
