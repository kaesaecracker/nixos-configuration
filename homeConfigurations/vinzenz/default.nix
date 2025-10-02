{ pkgs, ... }:
{
  imports = [
    ./editorconfig.nix
    ./fuzzel.nix
    ./git.nix
    ./gnome.nix
    ./ssh.nix
    ./vscode.nix
    ./zsh.nix
    ./starship.nix
    ./fonts.nix
    #./niri.nix
    #./swaylock.nix
    #./waybar.nix
  ];

  config = {
    programs = {
      home-manager.enable = true;
      fzf.enable = true;
      git-credential-oauth.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableZshIntegration = true;
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

      telegram-desktop
      element-desktop

      wireguard-tools
      wirelesstools

      kdiff3
      jetbrains-toolbox

      blanket
      vlc

      ptyxis

      arduino
      arduino-ide
      arduino-cli

      servicepoint-cli
      servicepoint-simulator

      icu

      nextcloud-client

      lutris

      foliate

      dconf2nix
    ];

    home.file = {
      "policy.json" = {
        target = ".config/containers/policy.json";
        text = builtins.readFile ./.config/containers/policy.json;
      };
      "idea.properties".text = "idea.filewatcher.executable.path = ${pkgs.fsnotifier}/bin/fsnotifier";
    };
  };
}
