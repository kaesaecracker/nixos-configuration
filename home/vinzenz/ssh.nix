{ ... }:
{
  config.programs.ssh = {
    enable = true;
    matchBlocks = {
      "vpn2" = {
        host = "vpn2 hetzner-vpn2";
        hostname = "2a01:4f8:c013:65dd::1";
        user = "root";
      };
      "openwrt" = {
        host = "openwrt openwrt.lan";
        hostname = "openwrt.lan";
        user = "root";
      };
      "openwrt-ts" = {
        hostname = "openwrt.donkey-pentatonic.ts.net";
        port = 2222;
        user = "root";
      };
      "openwrt-j" = {
        hostname = "openwrt.donkey-pentatonic.ts.net";
        proxyJump = "vpn1";
        port = 2222;
        user = "root";
      };
      "pc2-power" = {
        hostname = "openwrt.donkey-pentatonic.ts.net";
        proxyJump = "vpn1";
        port = 2222;
        user = "pc2-power";
      };
      "avd-power" = {
        # hostname = "2001:678:560:23:9833:63ff:fe2d:f477"
        # hostname = "195.160.172.25";
        hostname = "avd-jumphost.club.berlin.ccc.de";
        user = "power";
      };
      "avd" = {
        hostname = "avd.club.berlin.ccc.de";
        user = "vinzenz";
      };
      "builder.berlin.ccc.de" = {
        hostname = "195.160.172.36";
        user = "root";
      };
      "cccb.zerforschen.plus" = {
        hostname = "2a01:4f8:c013:cbdd::1";
        user = "root";
      };
      "berlin.ccc.de" = {
        hostname = "195.160.173.9";
        user = "deploy";
        port = 31337;
      };
      "forgejo-runner-1" = {
        hostname = "forgejo-runner-1.dev.zerforschen.plus";
        user = "root";
      };
    };
  };
}
