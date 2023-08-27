{
  config,
  pkgs,
  ...
}: {
  # Define user account
  users.users.vinzenz = {
    isNormalUser = true;
    description = "Vinzenz Schroeter";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    # openssh.authorizedKeys.keys = [ "ssh-dss AAAAB3NzaC1kc3MAAACBAPIkGWVEt4..." ];
  };

  # home manager
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
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
        ## Apps
        keepassxc
        steam
        wine-staging
        insync
        # gnome-secrets
        tdesktop
        lutris
        simple-scan
        wireguard-tools
        # steamlink
        element-desktop
        # youtube-music
        etcher
        ## system monitoring
        iotop
        radeontop
        lsof
        wirelesstools
        # lm-sensors
        ## command line niceness
        tldr
        powerline
        powerline-fonts
        thefuck
        ## development
        dotnet-sdk_7
        # gnome workbench
        jetbrains.rider
        alejandra
        arduino
        uucp
        screen
        jetbrains.pycharm-professional
        kdiff3
        docker
      ];

      file.".nanorc".text = ''
        set linenumbers
        set mouse
      '';
    };

    services = {
      kdeconnect = {
        enable = true;
        indicator = true;
      };
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

        initExtra = "eval \"$(direnv hook zsh)\"";

        shellAliases = {
          my-update = "sudo nixos-rebuild switch";
          my-fmt = "alejandra .";
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

        #package = pkgs.gitFull;
        #config.credential.helper = "libsecret";

        aliases = {
          prettylog = "log --pretty=oneline --graph";
        };
        extraConfig = {
          pull.ff = "only";
          init.defaultBranch = "main";
          merge.tool = "kdiff3";
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
          "editor.formatOnSaveMode" = "modificationsIfAvailiable";
          "editor.minimap.autohide" = true;
          "diffEditor.diffAlgorithm" = "advanced";
          "explorer.excludeGitIgnore" = true;
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

      bottom = {
        enable = true;
        settings = {
          # https://github.com/ClementTsang/bottom/blob/master/sample_configs/default_config.toml
        };
      };

      exa = {
        enable = true;
        # not availiable at 22.11
        # git = true;
        #   icons = true;
        # enableAliases = true;
        # extraOptions = [
        #   "--group-directories-first"
        #   "--header"
        # ];
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
}
