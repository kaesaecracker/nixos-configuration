{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "müde";
          email = "git@darkest.space";
        };

        aliases = {
          prettylog = "log --pretty=oneline --graph";
          spring-clean = "!git branch --merged | xargs -n 1 -r git branch -d";
        };

        pull.ff = "only";
        merge.tool = "kdiff3";
        push.autoSetupRemote = "true";
        credential.credentialStore = "cache";
      };

      ignores = [
        ".direnv"
        ".idea"
        ".envrc"
      ];
    };

    git-credential-oauth.enable = true;
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };
}
