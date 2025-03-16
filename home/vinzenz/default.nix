{ pkgs, config, ... }:
{
  imports = [
    ./configuration.nix
    ./editorconfig.nix
    ./git.nix
    ./gnome.nix
    ./niri.nix
    ./ssh.nix
    ./vscode.nix
    ./waybar.nix
    ./zsh.nix
  ];
}
