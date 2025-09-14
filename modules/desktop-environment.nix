{ pkgs, ... }:
{
  config = {
    programs.firefox.enable = true;

    environment.systemPackages = with pkgs; [
      lm_sensors

      # office
      #libreoffice-qt
      #hunspell
      #hunspellDicts.de-de
      #hunspellDicts.en-us-large
    ];

    fonts = {
      enableDefaultPackages = true;
      fontconfig.defaultFonts.monospace = [ "FiraCode Nerd Font" ];
      packages = with pkgs; [
        nerd-fonts.fira-code
        roboto-mono
        recursive
      ];
    };

    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
}
