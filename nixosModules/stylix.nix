{ pkgs, config, ... }:
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    override = {
      scheme = "Catppuccin Mocha Pride";

      base09 = "#6f9dff";
      base0A = "#d162a4";
      base0B = "#a8c9ff";
      base0C = "#a30262";

      # pink_light = "#d162a4";
      # pink_dark = "#a30262";
      # blue_light = "#5BCEFA";
      # blue_dark = "#4a6bb1";

      # original values
      # base00: "#1e1e2e" # base -
      # base01: "#181825" # mantle
      # base02: "#313244" # surface0
      # base03: "#45475a" # surface1
      # base04: "#585b70" # surface2
      # base05: "#cdd6f4" # text
      # base06: "#f5e0dc" # rosewater
      # base07: "#b4befe" # lavender
      # base08: "#f38ba8" # red
      # base09: "#fab387" # peach
      # base0A: "#f9e2af" # yellow
      # base0B: "#a6e3a1" # green
      # base0C: "#94e2d5" # teal
      # base0D: "#89b4fa" # blue
      # base0E: "#cba6f7" # mauve
      # base0F: "#f2cdcd" # flamingo

      # https://github.com/chriskempson/base16/blob/main/styling.md
      # base00 - Default Background
      # base01 - Lighter Background (Used for status bars, line number and folding marks)
      # base02 - Selection Background
      # base03 - Comments, Invisibles, Line Highlighting
      # base04 - Dark Foreground (Used for status bars)
      # base05 - Default Foreground, Caret, Delimiters, Operators
      # base06 - Light Foreground (Not often used)
      # base07 - Light Background (Not often used)
      # base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      # base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
      # base0A - Classes, Markup Bold, Search Text Background
      # base0B - Strings, Inherited Class, Markup Code, Diff Inserted
      # base0C - Support, Regular Expressions, Escape Characters, Markup Quotes
      # base0D - Functions, Methods, Attribute IDs, Headings
      # base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
      # base0F - Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    };
    image = config.lib.stylix.pixel "base00";
    polarity = "dark";
    targets = {
      gnome.enable = false;
      gtk.enable = false;
      gtksourceview.enable = false;
      fontconfig.enable = true;
      plymouth.enable = false;
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
