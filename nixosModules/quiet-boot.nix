{ pkgs, ... }:
{
  boot = {
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    consoleLogLevel = 0;
    initrd = {
      verbose = false;
      systemd.enable = true; # required fpr graphical LUKS prompt
    };
    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = [
        (pkgs.catppuccin-plymouth.override {
          variant = "mocha";
        })
      ];
    };
  };
}
