{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}: let
  isGnomeEnabled = osConfig.my.desktop.enableGnome;
in
  lib.mkMerge [
    {
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

      programs = {
        home-manager.enable = true;

        fzf.enable = true;

        zsh = {
          initExtra = ''
            eval "$(direnv hook zsh)";
            export PATH=$PATH:/home/vinzenz/.cargo/bin
          '';

          shellAliases = {
            my-apply = "sudo nixos-rebuild boot";
            my-switch = "sudo nixos-rebuild switch";
            my-update = "sudo nixos-rebuild boot --upgrade";
            my-pull = "git -C ~/Repos/nixos-configuration pull --rebase";
            my-fmt = "alejandra .";
            my-test = "sudo nixos-rebuild test";
            my-direnvallow = "echo \"use nix\" > .envrc && direnv allow";
            my-ip4 = "ip addr show | grep 192";
          };

          history = {
            size = 10000;
            path = "${config.xdg.dataHome}/zsh/history";
            expireDuplicatesFirst = true;
          };

          oh-my-zsh = {
            enable = true;
            theme = "agnoster";
            plugins = ["git" "sudo" "docker" "systemadmin"];
          };
        };

        git = {
          enable = true;
          userName = "Vinzenz Schroeter";
          userEmail = "vinzenz.f.s@gmail.com";

          aliases = {
            prettylog = "log --pretty=oneline --graph";
            spring-clean = "!git branch --merged | xargs -n 1 -r git branch -d";
          };

          extraConfig = {
            pull.ff = "only";
            merge.tool = "kdiff3";
            push.autoSetupRemote = "true";
          };
        };

        vscode = {
          enable = true;
          package = pkgs.vscodium;
          enableUpdateCheck = false;
          extensions = with pkgs.vscode-extensions; [
            bbenoist.nix
            ms-python.python
            kamadorueda.alejandra
            editorconfig.editorconfig
            yzhang.markdown-all-in-one
            redhat.vscode-yaml
            pkief.material-icon-theme
            mhutchie.git-graph
            rust-lang.rust-analyzer
            tamasfe.even-better-toml
            llvm-vs-code-extensions.vscode-clangd
            mkhl.direnv
            vadimcn.vscode-lldb
            ms-dotnettools.csharp
          ];
          userSettings = {
            "git.autofetch" = true;
            "update.mode" = "none";
            "editor.fontFamily" = "'Fira Code', 'Droid Sans Mono', 'monospace', monospace";
            "editor.fontLigatures" = true;
            "editor.formatOnSave" = true;
            "editor.formatOnSaveMode" = "modificationsIfAvailable";
            "editor.minimap.autohide" = true;
            "diffEditor.diffAlgorithm" = "advanced";
            "explorer.excludeGitIgnore" = true;
            "markdown.extension.tableFormatter.normalizeIndentation" = true;
            "markdown.extension.toc.orderedList" = false;
            "telemetry.telemetryLevel" = "off";
            "redhat.telemetry.enabled" = false;
            "workbench.startupEditor" = "readme";
            "workbench.enableExperiments" = false;
            "workbench.iconTheme" = "material-icon-theme";
            "rust-analyzer.checkOnSave.command" = "clippy";
            "extensions.autoUpdate" = false;
            "extensions.autoCheckUpdates" = false;
            "\[makefile\]" = {
              "editor.insertSpaces" = false;
              "editor.detectIndentation" = false;
            };
          };
        };

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

        # checked https://rycee.gitlab.io/home-manager/options.html until "programs.notmuch"

        ssh = {
          enable = true;
          matchBlocks = {
            "vpn1" = {
              host = "vpn1 hetzner-vpn1";
              hostname = "157.90.146.125"; # 2a01:4f8:c012:7137::/64
              user = "root";
            };
            "vpn1-ts" = {
              host = "vpn1-ts hetzner-vpn1.donkey-pentatonic.ts.net";
              hostname = "hetzner-vpn1.donkey-pentatonic.ts.net";
              user = "root";
            };
            "openwrt" = {
              host = "openwrt openwrt.lan";
              hostname = "openwrt.lan";
              user = "root";
            };
            "openwrt-ts" = {
              hostname = "openwrt.donkey-pentatonic.ts.net";
              port = 2222;
              user = "root";
            };
            "openwrt-j" = {
              hostname = "openwrt.donkey-pentatonic.ts.net";
              proxyJump = "vpn1";
              port = 2222;
              user = "root";
            };
            "pc2-power" = {
              hostname = "openwrt.donkey-pentatonic.ts.net";
              proxyJump = "vpn1";
              port = 2222;
              user = "pc2-power";
            };
            "avd-power" = {
              # hostname = "2001:678:560:23:9833:63ff:fe2d:f477"
              # hostname = "195.160.172.25";
              hostname = "avd-jumphost.club.berlin.ccc.de";
              user = "power";
            };
            "avd" = {
              hostname = "avd.club.berlin.ccc.de";
              user = "vinzenz";
            };
          };
        };
      };

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
  ]
