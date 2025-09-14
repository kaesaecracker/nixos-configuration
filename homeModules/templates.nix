{
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
}
