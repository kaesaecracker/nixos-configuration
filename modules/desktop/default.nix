modulesCfg: {
  config,
  pkgs,
  lib,
  ...
}: let
  enableHomeManager = modulesCfg.enableHomeManager;
  cfg = config.my.desktop;
in {
  imports =
    [
      ./gnome.nix
      ./kde.nix
      ./vinzenz.nix
      ./ronja.nix
      ./gaming.nix
    ]
    ++ lib.optionals enableHomeManager [
      <home-manager/nixos>
    ];

  options.my.modulesCfg.enableHomeManager = lib.mkEnableOption "enable home manager";

  options.my.desktop.enable = lib.mkEnableOption "desktop";

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

    systemd = {
      # save some boot time because nothing actually requires network connectivity
      services.NetworkManager-wait-online.enable = false;

      extraConfig = ''
        DefaultTimeoutStopSec=12s
      '';
    };

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
      ];
    };

    nixpkgs.config.permittedInsecurePackages = [
      "electron-12.2.3"
    ];

    fonts = {
      fontconfig.defaultFonts.monospace = ["FiraCode Nerd Font"];
      fonts = with pkgs; [
        (nerdfonts.override {fonts = ["FiraCode"];})
      ];
    };
  };
}
