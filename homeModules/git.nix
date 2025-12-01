{
  programs = {
    git = {
      enable = true;
      settings.init.defaultBranch = "main";
    };

    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };
}
