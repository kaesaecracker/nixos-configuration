{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.my.latex.enable = lib.mkEnableOption "LaTeX (texliveFull + TeXstudio)";

  config = lib.mkIf config.my.latex.enable {
    environment.systemPackages = with pkgs; [
      fontconfig
      texliveFull
      texstudio
    ];
  };
}
