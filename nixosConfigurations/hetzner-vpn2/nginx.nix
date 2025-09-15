{ pkgs, ... }:
let
  blog-domain-socket = "/run/nginx/blog.sock";
  anubis-domain-socket = "/run/anubis/anubis-blog.sock";
in
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@zerforschen.plus";
  };

  systemd.services = {
    nginx.serviceConfig.SupplementaryGroups = [ "anubis" ];
    anubis-main.serviceConfig.SupplementaryGroups = [ "nginx" ];
  };

  services = {
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;

      virtualHosts = {
        "zerforschen.plus" = {
          addSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://unix:" + anubis-domain-socket;
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
    };

    anubis.instances.main = {
      enable = true;
      settings = {
        BIND = anubis-domain-socket;
        TARGET = "unix://" + blog-domain-socket;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    5201
  ];
}
