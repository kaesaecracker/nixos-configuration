{ lib, config, ... }:
{
  options.my.prometheusNode.enable = lib.mkEnableOption "Prometheus node exporter";

  config = lib.mkIf config.my.prometheusNode.enable {
    services.prometheus.exporters = {
      node = {
        enable = true;
        openFirewall = true;
        port = 9190;
        enabledCollectors = [
          # keep-sorted start
          "cgroups"
          "interrupts"
          "softirqs"
          "swap"
          "systemd"
          "tcpstat"
          "wifi"
          # keep-sorted end
        ];
      };
    };
  };
}
