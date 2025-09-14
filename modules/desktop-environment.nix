{ pkgs, ... }:
{
  config = {
    services = {
      xserver.enable = true;
      libinput.enable = true;
      flatpak.enable = true;
      fstrim.enable = true;
      earlyoom = {
        enable = true;
        freeMemThreshold = 5;
      };
    };

    # Enable sound with pipewire.
    security.rtkit.enable = true;
    services = {
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        #jack.enable = true;
      };
    };

    programs = {
      firefox = {
        enable = true;
        languagePacks = [
          "en-US"
          "de"
        ];
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
      xwayland.enable = true;
    };

    systemd = {
      # save some boot time because nothing actually requires network connectivity
      services.NetworkManager-wait-online.enable = false;

      # prevent stuck units from preventing shutdown (default is 120s)
      extraConfig = ''
        DefaultTimeoutStopSec=10s
      '';
    };

    environment.systemPackages = with pkgs; [
      lm_sensors

      # office
      libreoffice-qt
      hunspell
      hunspellDicts.de-de
      hunspellDicts.en-us-large
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

    system.autoUpgrade = {
      allowReboot = false;
      operation = "boot";
    };
  };
}
