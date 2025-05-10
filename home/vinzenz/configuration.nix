{ pkgs, ... }:
{
  programs = {
    home-manager.enable = true;
    fzf.enable = true;
    git-credential-oauth.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      git = true;
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };

    thefuck = {
      enable = true;
      enableZshIntegration = true;
    };

    chromium.enable = true;
  };

  home.packages = with pkgs; [
    keepassxc
    insync

    telegram-desktop
    element-desktop

    wireguard-tools
    wirelesstools

    kdiff3
    jetbrains-toolbox

    blanket
    vlc

    arduino
    arduino-ide
    arduino-cli
    kicad
    kikit

    unstable.ut1999

    servicepoint-cli
    servicepoint-simulator
  ];

  home.file."policy.json" = {
    target = ".config/containers/policy.json";
    text = builtins.readFile ./.config/containers/policy.json;
  };
}
