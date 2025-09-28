{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.zsh-powerlevel10k = {
    enable = lib.mkEnableOption "powerlevel10k zsh theme";
    package = lib.mkPackageOption pkgs "zsh-powerlevel10k" { nullable = true; };
  };

  config =
    let
      cfg = config.programs.zsh-powerlevel10k;
      p10k = if (cfg.package != null) then cfg.package else pkgs.zsh-powerlevel10k;
    in
    lib.mkIf cfg.enable {
      programs.zsh.initContent = ''
        source ${p10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      '';
    };
}
