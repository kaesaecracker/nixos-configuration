{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.my.globalinstalls.enable = lib.mkEnableOption "global system packages and tools";

  config = lib.mkIf config.my.globalinstalls.enable {
    environment.systemPackages = with pkgs; [
      ncdu
      glances
      lsof
      dig
      screen
      tldr
      nix-output-monitor
    ];

    programs = {
      zsh.enable = true;
      htop.enable = true;
      iotop.enable = true;
      nano = {
        enable = true;
        syntaxHighlight = true;
      };
    };
  };
}
