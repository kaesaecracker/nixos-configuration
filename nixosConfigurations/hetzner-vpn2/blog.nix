{ pkgs, ... }:
let
  blog-domain-socket = "/run/nginx/blog.sock";
  anubis-domain-socket = "/run/anubis/anubis-main/anubis.sock";
  anubis-metrics-socket = "/run/anubis/anubis-main/anubis-metrics.sock";
in
{
  systemd.services = {
    nginx.serviceConfig.SupplementaryGroups = [ "anubis" ];
    anubis-main.serviceConfig.SupplementaryGroups = [ "nginx" ];
  };

  services = {
    nginx.virtualHosts = {
      "zerforschen.plus" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/_metrics".proxyPass = "http://unix:" + anubis-metrics-socket + ":/metrics";
          "/".proxyPass = "http://unix:" + anubis-domain-socket;
        };
      };

      "blog-in-anubis" = {
        root = pkgs.zerforschen-plus-content;
        listen = [
          {
            addr = "unix:" + blog-domain-socket;
          }
        ];
      };
    };

    anubis.instances.main = {
      enable = true;
      settings = {
        BIND = anubis-domain-socket;
        TARGET = "unix://" + blog-domain-socket;
        METRICS_BIND = anubis-metrics-socket;
      };
    };
  };
}
