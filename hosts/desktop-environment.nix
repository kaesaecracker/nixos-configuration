{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    services = {
      # Enable the X11 windowing system / wayland depending on DE
      xserver = {
        enable = true;
      };

      libinput.enable = true;

      # flatpak xdg-portal-kde crashes, otherwise this would be global
      flatpak.enable = true;

      fstrim.enable = true;

      earlyoom = {
        enable = true;
        freeMemThreshold = 5;
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
      #jack.enable = true;
    };

    programs = {
      kdeconnect.enable = true;
      firefox = {
        enable = true;
        languagePacks = ["en-US" "de"];
      };
      nix-ld = {
        enable = true;
        libraries = with pkgs; [
          stdenv.cc.cc
          zlib
          zstd
          curl
          openssl
          attr
          libssh
          bzip2
          libxml2
          acl
          libsodium
          util-linux
          xz
          systemd
        ];
      };
      appimage = {
        enable = true;
        binfmt = true;
      };
    };

    networking = {
      networkmanager.enable = true;

      firewall = {
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

    environment.systemPackages = with pkgs; [
      lm_sensors

      # office
      libreoffice-qt
      hunspell
      hunspellDicts.de-de
      hunspellDicts.en-us-large

      gnumake
    ];

    nixpkgs.config.permittedInsecurePackages = [];

    my.allowUnfreePackages = [
      "insync"
      "insync-pkg"

      "rider"
      "pycharm-professional"
      "jetbrains-toolbox"

      "anydesk"
    ];

    fonts = {
      enableDefaultPackages = true;
      fontconfig.defaultFonts.monospace = ["FiraCode Nerd Font"];
      packages = with pkgs; [
        (nerdfonts.override {fonts = ["FiraCode"];})
      ];
    };

    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
}
