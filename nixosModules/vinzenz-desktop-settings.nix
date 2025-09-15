{ pkgs, ... }:
{
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
    libreoffice-qt6
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

  # RDP connections
  services.gnome.gnome-remote-desktop.enable = true;
  networking.firewall.allowedTCPPorts = [ 3389 ];
}
