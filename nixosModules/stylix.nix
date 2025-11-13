{ pkgs, ... }:
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";
    targets = {
      gnome.enable = false;
      gtk.enable = false;
      gtksourceview.enable = false;
      fontconfig.enable = true;
    };
    fonts = {
      sansSerif = {
        name = "Inter Nerd Font";
        package = pkgs.inter-nerdfont;
      };
      monospace = {
        name = "FiraCode Nerd Font Mono";
        package = pkgs.nerd-fonts.fira-code;
      };
    };
    icons = {
      enable = true;
      dark = "Adwaita";
      light = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursor = {
      name = "Adwaita";
      size = 16;
      package = pkgs.adwaita-icon-theme;
    };
  };
}
