{
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

  ignores = [
    ".direnv"
    ".idea"
    ".envrc"
  ];
}
