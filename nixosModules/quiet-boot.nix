{
  boot = {
    kernelParams = [
      "quiet"
      "udev.log_level=3"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth.enable = true;
  };
}
