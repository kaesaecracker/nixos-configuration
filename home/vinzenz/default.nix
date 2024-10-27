inputs@{ pkgs, ... }:
{
  programs = {
    home-manager.enable = true;
    fzf.enable = true;
    zsh = import ./zsh.nix inputs;
    git = import ./git.nix;
    vscode = import ./vscode.nix inputs;
    ssh = import ./ssh.nix;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      git = true;
      icons = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
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

    alejandra # nix formatter

    arduino
    uucp

    kdiff3
    jetbrains-toolbox
  ];

  home.file."policy.json" = {
    target = ".config/containers/policy.json";
    text = ''
      {
          "default": [
              {
                  "type": "insecureAcceptAnything"
              }
          ],
          "transports":
              {
                  "docker-daemon":
                      {
                          "": [{"type":"insecureAcceptAnything"}]
                      }
              }
      }
    '';
  };
}
