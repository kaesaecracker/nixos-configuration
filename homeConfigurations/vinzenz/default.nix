{ pkgs, ... }:
{
  imports = [
    # keep-sorted start
    ./editorconfig.nix
    ./fonts.nix
    ./fuzzel.nix
    ./git.nix
    ./gnome.nix
    ./mako.nix
    ./niri.nix
    ./ssh.nix
    ./starship.nix
    ./swaylock.nix
    ./vscode.nix
    ./waybar.nix
    ./zsh.nix
    # keep-sorted end
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
      nextcloud-client
      thunderbird
      fractal

      telegram-desktop
      element-desktop

      wireguard-tools
      wirelesstools
      tailscale

      kdiff3
      jetbrains-toolbox

      vlc
      lutris

      arduino
      arduino-ide
      arduino-cli

      servicepoint-cli
      servicepoint-simulator

      icu

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
