{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.my.desktop;
in {
  imports = [
    ./gnome.nix
    ./kde.nix
  ];

  options.my.desktop = {
    enable = lib.mkEnableOption "desktop";
  };

  config = lib.mkIf cfg.enable {
    services = {
      # Enable the X11 windowing system / wayland depending on DE
      xserver.enable = true;

      # Enable CUPS to print documents.
      printing.enable = true;

      openssh.settings.PermitRootLogin = "no";
    };

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      };
    };

    # unblock kde connect / gsconnect
    networking.firewall = {
      allowedTCPPortRanges = [
        {
          # KDE Connect
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          # KDE Connect
          from = 1714;
          to = 1764;
        }
      ];
    };
  };
}
