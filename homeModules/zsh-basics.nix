{ lib, config, ... }:
{
  options.my.zsh.enable = lib.mkEnableOption "zsh with basic settings";

  config = lib.mkIf config.my.zsh.enable {
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
  };
}
