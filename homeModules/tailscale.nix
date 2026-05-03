{
  lib,
  config,
  osConfig,
  thisDevice,
  ...
}:
{
  options.my.tailscale.enable = lib.mkOption {
    type = lib.types.bool;
    default = (thisDevice.isDesktop or false) && osConfig.my.tailscale.enable;
    description = "Whether to enable the Tailscale system tray applet. Defaults to true on desktops with Tailscale enabled.";
  };

  config = lib.mkIf config.my.tailscale.enable {
    services.tailscale-systray.enable = true;
  };
}
