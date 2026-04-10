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
    git-credential-oauth
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

  environment.etc."gitconfig".text = ''
    [credential]
      helper = oauth
      credentialStore = cache
  '';
}
