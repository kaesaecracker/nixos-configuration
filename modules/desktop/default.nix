modulesCfg: {
  config,
  pkgs,
  lib,
  ...
}: let
  isEnabled = config.my.desktop.enable;
  isHomeManager = modulesCfg.enableHomeManager;
in {
  imports =
    [
      ./gnome.nix
      ./kde.nix
      ./gaming.nix
      ./printing.nix
    ]
    ++ lib.optionals isHomeManager [
      ./gnome-home.nix
      ./kde-home.nix
    ];

  options.my.desktop.enable = lib.mkEnableOption "desktop";

  config = lib.mkIf isEnabled {
    services = {
      # Enable the X11 windowing system / wayland depending on DE
      xserver = {
        enable = true;
        libinput.enable = true;
      };

      # flatpak xdg-portal-kde crashes, otherwise this would be global
      flatpak.enable = true;
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
      #jack.enable = true;
    };

    programs = {
      kdeconnect.enable = true;
      firefox = {
        enable = true;
        languagePacks = ["en-US" "de"];
      };
    };

    networking = {
      networkmanager.enable = true;

      firewall = {
        enable = true;
        allowedTCPPortRanges = [
          {
            # KDE Connect / gsconnect
            from = 1714;
            to = 1764;
          }
        ];
        allowedUDPPortRanges = [
          {
            # KDE Connect / gsconnect
            from = 1714;
            to = 1764;
          }
        ];
      };
    };

    systemd = {
      # save some boot time because nothing actually requires network connectivity
      services.NetworkManager-wait-online.enable = false;

      # prevent stuck units from preventing shutdown (default is 120s)
      extraConfig = ''
        DefaultTimeoutStopSec=12s
      '';
    };

    environment = {
      systemPackages = with pkgs; [
        lm_sensors

        # office
        libreoffice-qt
        hunspell
        hunspellDicts.de-de
        hunspellDicts.en-us-large
      ];
    };

    nixpkgs.config.permittedInsecurePackages = [
      "electron-19.1.9"
    ];

    my.allowUnfreePackages = [
      "insync"
      "insync-pkg"

      "rider"
      "pycharm-professional"
      "jetbrains-toolbox"
    ];

    fonts = {
      enableDefaultPackages = true;
      fontconfig.defaultFonts.monospace = ["FiraCode Nerd Font"];
      packages = with pkgs; [
        (nerdfonts.override {fonts = ["FiraCode"];})
      ];
    };
  };
}
