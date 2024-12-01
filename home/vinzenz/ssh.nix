{
  enable = true;
  matchBlocks = {
    "vpn1" = {
      host = "vpn1 hetzner-vpn1";
      hostname = "157.90.146.125"; # 2a01:4f8:c012:7137::/64
      user = "root";
    };
    "vpn2" = {
      host = "vpn2 hetzner-vpn2";
      hostname = "2a01:4f8:c013:65dd::1";
      user = "root";
    };
    "vpn1-ts" = {
      host = "vpn1-ts hetzner-vpn1.donkey-pentatonic.ts.net";
      hostname = "hetzner-vpn1.donkey-pentatonic.ts.net";
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
  };
}
