{ lib, config, ... }:
{
  options.my.templates.enable = lib.mkEnableOption "file templates";

  config = lib.mkIf config.my.templates.enable {
    home.file = {
      "Templates/Empty file".text = "";
      "Templates/Empty bash script".text = ''
        #!/usr/bin/env bash
        # abort on error, undefined variables
        set -eu
        # print commands before execution
        set -x
      '';
    };
  };
}
