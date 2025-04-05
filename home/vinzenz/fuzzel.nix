{ pkgs, ... }:
{
  config.programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.alacritty}/bin/alacritty";
        icon-theme = "Adwaita";
        counter = true;
        font = "sans:size=10";
      };
      colors = {
        border = "0003B3FF";
        background = "0F0F0FFF";
        text = "657b83ff";
        prompt = "586e75ff";
        placeholder = "93a1a1ff";
        input = "657b83ff";
        match = "cb4b16ff";
        selection = "eee8d5ff";
        selection-text = "586e75ff";
        selection-match = "cb4b16ff";
        counter = "93a1a1ff";
      };
      border = {
        radius = 30;
        width = 3;
      };
    };
  };
}
