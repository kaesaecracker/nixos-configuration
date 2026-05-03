{ osConfig, thisDevice, ... }:
{
  services.tailscale-systray.enable = (thisDevice.isDesktop or false) && osConfig.my.tailscale.enable;
}
