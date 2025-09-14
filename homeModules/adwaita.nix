{ pkgs, ... }:
{
  gtk = {
    enable = true;
    iconTheme.name = "Adwaita";
    cursorTheme.name = "Adwaita";
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };
}
