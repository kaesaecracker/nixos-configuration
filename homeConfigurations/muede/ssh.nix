{
  config.programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "vpn2 hetzner-vpn2" = {
        HostName = "2a01:4f8:c013:65dd::1";
        User = "root";
      };
      "openwrt openwrt.lan" = {
        HostName = "openwrt.lan";
        User = "root";
      };
      "openwrt-ts" = {
        HostName = "openwrt.donkey-pentatonic.ts.net";
        Port = 2222;
        User = "root";
      };
      "openwrt-j" = {
        HostName = "openwrt.donkey-pentatonic.ts.net";
        ProxyJump = "vpn1";
        Port = 2222;
        User = "root";
      };
      "pc2-power" = {
        HostName = "openwrt.donkey-pentatonic.ts.net";
        ProxyJump = "vpn1";
        Port = 2222;
        User = "pc2-power";
      };
      "avd-power" = {
        # HostName = "2001:678:560:23:9833:63ff:fe2d:f477"
        # HostName = "195.160.172.25";
        HostName = "avd-jumphost.club.berlin.ccc.de";
        User = "power";
      };
      "avd" = {
        HostName = "avd.club.berlin.ccc.de";
        User = "vinzenz";
      };
      "builder.berlin.ccc.de" = {
        HostName = "195.160.172.36";
        User = "root";
      };
      "cccb.zerforschen.plus" = {
        HostName = "2a01:4f8:c013:cbdd::1";
        User = "root";
      };
      "berlin.ccc.de" = {
        HostName = "195.160.173.9";
        User = "deploy";
        Port = 31337;
      };
      "forgejo-runner-1" = {
        HostName = "forgejo-runner-1.dev.zerforschen.plus";
        User = "root";
      };
    };
  };
}
