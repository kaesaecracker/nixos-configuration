{
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

  systemd = {
    # save some boot time because nothing actually requires network connectivity
    services.NetworkManager-wait-online.enable = false;

    # prevent stuck units from preventing shutdown (default is 120s)
    settings.Manager.DefaultTimeoutStopSec = "10s";
  };

  programs = {
    xwayland.enable = true;

    appimage = {
      enable = true;
      binfmt = true;
    };
  };

  system.autoUpgrade = {
    allowReboot = false;
    operation = "boot";
  };
}
