{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.my.desktop;
in {
  imports = [
    <home-manager/nixos>
    ../_common
    ./gnome.nix
    ./kde.nix
    ./vinzenz.nix
    ./ronja.nix
  ];

  options.my.desktop = {
    enable = lib.mkEnableOption "desktop";
  };

  config = lib.mkIf cfg.enable {
    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = true;

    services = {
      # Enable the X11 windowing system / wayland depending on DE
      xserver.enable = true;

      # Enable CUPS to print documents.
      printing.enable = true;

      # Enable the OpenSSH daemon.
      openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };
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
    networking = {
      networkmanager.enable = true;
      firewall.enable = true;

      firewall = {
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

    systemd.extraConfig = ''
      DefaultTimeoutStopSec=12s
    '';

    programs = {
      zsh.enable = true;

      git = {
        enable = true;
        package = pkgs.gitFull;
      };
    };

    environment = {
      pathsToLink = ["/share/zsh"];

      systemPackages = with pkgs; [
        lm_sensors
        tldr
        ncdu
      ];
    };

    nixpkgs.config.permittedInsecurePackages = [
      "electron-12.2.3"
    ];
  };
}
