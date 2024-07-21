{
  config,
  pkgs,
  lib,
  ...
}: let
  isEnabled = config.my.desktop.enableLaTeX;
in {
  options.my.desktop.enableLaTeX = lib.mkEnableOption "LaTeX tools and IDE";

  config = lib.mkIf isEnabled {
    my.desktop.enable = true;

    environment.systemPackages = with pkgs; [
      fontconfig
      texliveFull
      texstudio
    ];
  };
}
