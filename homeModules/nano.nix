{ lib, config, ... }:
{
  options.my.nano.enable = lib.mkEnableOption "nano editor config";

  config = lib.mkIf config.my.nano.enable {
    home = {
      sessionVariables.EDITOR = "nano";
      file.".nanorc".text = ''
        set linenumbers
        set mouse
      '';
    };
  };
}
