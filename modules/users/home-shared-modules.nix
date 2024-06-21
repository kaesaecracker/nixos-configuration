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
        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;
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
        gitCredentialHelper.enable = true;
      };
    };
  }
  # Templates
  {
    home.file = {
      "Templates/Empty file".text = "";
      "Templates/Empty bash script".text = ''
        #!/usr/bin/env bash
        # abort on error, undefined variables
        set -eu
        # print commands before execution
        set -x
      '';
    };
  }
]
