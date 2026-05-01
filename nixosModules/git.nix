{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.my.git.enable = lib.mkEnableOption "git with credential helper";

  config = lib.mkIf config.my.git.enable {
    environment.systemPackages = [ pkgs.git-credential-oauth ];

    programs.git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        credential = {
          helper = "oauth";
          credentialStore = "cache";
        };
      };
    };
  };
}
