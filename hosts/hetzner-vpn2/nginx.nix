{ inputs, pkgs, ... }:
let
  blog-domain-socket = "/run/nginx/blog.sock";
  anubis-domain-socket = "/run/anubis/anubis-blog.sock";
in
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@zerforschen.plus";
  };

  security.pam.services.nginx.setEnvironment = false;
  systemd.services = {
    nginx.serviceConfig = {
      SupplementaryGroups = [
        "shadow"
        "anubis"
      ];
    };
    anubis-main.serviceConfig = {
      SupplementaryGroups = [ "nginx" ];
    };
  };

  services = {
    nginx = {
      enable = true;
      additionalModules = [ pkgs.nginxModules.pam ];

      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;

      virtualHosts =
        #let
        #  servicesDomain = "services.zerforschen.plus";
        #  mkServiceConfig =
        #    { host, port }:
        #    {
        #      addSSL = true;
        #      enableACME = true;
        #      locations."/" = {
        #        proxyPass = "http://${host}:${toString port}/";
        #        extraConfig = ''
        #          # bind to tailscale ip
        #          proxy_bind 100.88.118.60;
        #          # pam auth
        #          limit_except OPTIONS {
        #            auth_pam  "Password Required";
        #            auth_pam_service_name "nginx";
        #          }
        #        '';
        #      };
        #    };
        #  pc2 = "vinzenz-pc2.donkey-pentatonic.ts.net";
        #in
        {
          #"code.${servicesDomain}" = lib.mkMerge [
          #  (mkServiceConfig {
          #    host = pc2;
          #    port = 8542;
          #  })
          #  { locations."/".proxyWebsockets = true; }
          #];
          #"view.${servicesDomain}" = mkServiceConfig {
          #  host = pc2;
          #  port = 1313;
          #};

          "zerforschen.plus" = {
            addSSL = true;
            enableACME = true;
            locations."/" = {
              proxyPass = ("http://unix:" + anubis-domain-socket);
            };
          };

          "blog-in-anubis" = {
            root = inputs.zerforschen-plus.packages."${pkgs.system}".zerforschen-plus-content;
            listen = [
              {
                addr = ("unix:" + blog-domain-socket);
              }
            ];
          };
        };
    };

    anubis = {
      instances.main = {
        enable = true;
        settings = {
          BIND = anubis-domain-socket;
          TARGET = "unix://" + blog-domain-socket;
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    5201
  ];
}
