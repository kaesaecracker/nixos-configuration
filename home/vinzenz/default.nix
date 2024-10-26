inputs @ {
  config,
  osConfig,
  pkgs,
  lib,
  ...
}: let
  isGnomeEnabled = osConfig.my.desktop.enableGnome;
in {
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

    chromium = {
      enable = true;
      extensions = [
        {
          # ublock origin
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
        }
        {
          id = "dcpihecpambacapedldabdbpakmachpb";
          updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/updates.xml";
        }
      ];
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

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        insert_final_newline = true;
        max_line_width = 120;
        indent_style = "space";
        indent_size = 4;
      };
      "*.nix" = {
        indent_size = 2;
      };
    };
  };

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
