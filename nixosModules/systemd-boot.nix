{
  boot.loader = {
    timeout = 3;
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      editor = false; # do not allow changing kernel parameters
      consoleMode = "max";
    };
  };
}
