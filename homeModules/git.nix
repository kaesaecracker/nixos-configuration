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
