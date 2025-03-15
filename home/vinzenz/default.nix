inputs@{ pkgs, ... }:
{
  imports = [ ./gnome.nix ];

  config = {
    programs = {
      home-manager.enable = true;
      fzf.enable = true;
      zsh = import ./zsh.nix inputs;
      git = import ./git.nix;
      vscode = import ./vscode.nix inputs;
      ssh = import ./ssh.nix;
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
    };

    editorconfig = import ./editorconfig.nix;

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
    ];

    home.file."policy.json" = {
      target = ".config/containers/policy.json";
      text = builtins.readFile ./.config/containers/policy.json;
    };
  };
}
