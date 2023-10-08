[
  # set stateVersion
  {
    home.stateVersion = "22.11";
  }
  # make nano the default editor
  {
    home = {
      sessionVariables.EDITOR = "nano";
      file.".nanorc".text = ''
        set linenumbers
        set mouse
      '';
    };
  }
  # command line niceness
  {
    programs = {
      command-not-found.enable = true;
      dircolors.enable = true;

      zsh = {
        enable = true;
        enableSyntaxHighlighting = true;
        enableAutosuggestions = true;
        enableVteIntegration = true;
      };
    };
  }
  # common git config
  {
    programs = {
      git = {
        enable = true;
        extraConfig.init.defaultBranch = "main";
      };

      gh = {
        enable = true;
        enableGitCredentialHelper = true;
      };
    };
  }
]