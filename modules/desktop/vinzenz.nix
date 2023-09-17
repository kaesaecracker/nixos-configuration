{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.my.desktop.vinzenz;
in {
  config = lib.mkIf cfg.enable {
    # Define user account
    users.users.vinzenz = {
      isNormalUser = true;
      description = "Vinzenz Schroeter";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
    };

    # home manager
    home-manager.users.vinzenz = {
      config,
      pkgs,
      ...
    }: {
      home = {
        username = "vinzenz";
        homeDirectory = "/home/vinzenz";
        stateVersion = "22.11";

        sessionVariables = {
          EDITOR = "nano";
        };

        packages = with pkgs; [
          keepassxc
          steam
          insync
          telegram-desktop
          simple-scan
          wireguard-tools
          element-desktop
          etcher
          iotop
          radeontop
          lsof
          wirelesstools
          thefuck
          dotnet-sdk_7
          jetbrains.rider
          alejandra
          arduino
          uucp
          screen
          jetbrains.pycharm-professional
          kdiff3
          docker
          wineWowPackages.stagingFull
          wineWowPackages.fonts
          winetricks
          youtube-music

          (lutris.override {
            extraPkgs = pkgs: [
              # List package dependencies here
            ];
            extraLibraries = pkgs: [
              # List library dependencies here
            ];
          })
        ];

        file.".nanorc".text = ''
          set linenumbers
          set mouse
        '';
      };

      programs = {
        home-manager.enable = true;

        firefox.enable = true;
        command-not-found.enable = true;
        dircolors.enable = true;
        fzf.enable = true;
        htop.enable = true;

        zsh = {
          enable = true;

          enableSyntaxHighlighting = true;
          enableAutosuggestions = true;
          enableVteIntegration = true;

          initExtra = ''
            eval "$(direnv hook zsh)";
            eval $(thefuck --alias);
          '';

          shellAliases = {
            my-apply = "sudo nixos-rebuild boot";
            my-switch = "sudo nixos-rebuild switch";
            my-update = "sudo nixos-rebuild boot --upgrade";
            my-fmt = "alejandra .";
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
            plugins = ["git" "sudo" "docker" "systemadmin" "thefuck"];
          };
        };

        git = {
          enable = true;
          userName = "Vinzenz Schroeter";
          userEmail = "vinzenz.f.s@gmail.com";

          aliases = {
            prettylog = "log --pretty=oneline --graph";
          };

          extraConfig = {
            pull.ff = "only";
            init.defaultBranch = "main";
            merge.tool = "kdiff3";
            push.autoSetupRemote = "true";
          };
        };

        gh = {
          enable = true;
          enableGitCredentialHelper = true;
        };

        vscode = {
          enable = true;
          package = pkgs.vscodium;
          enableUpdateCheck = false;
          extensions = with pkgs; [
            vscode-extensions.bbenoist.nix
            vscode-extensions.ms-python.python
            vscode-extensions.kamadorueda.alejandra
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
            "workbench.startupEditor" = "readme";
            "markdown.extension.tableFormatter.normalizeIndentation" = true;
            "markdown.extension.toc.orderedList" = false;
            "telemetry.telemetryLevel" = "off";
            "redhat.telemetry.enabled" = false;
            "workbench.enableExperiments" = false;
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

        exa = {
          enable = true;
          git = true;
          icons = true;
          enableAliases = true;
          extraOptions = [
            "--group-directories-first"
            "--header"
          ];
        };

        # checked https://rycee.gitlab.io/home-manager/options.html until "programs.jq"
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
    };
  };
}
