{ pkgs, ... }:
let
  blog-domain-socket = "/run/nginx/blog.sock";
  anubis-domain-socket = "/run/anubis/anubis-blog.sock";
in
{
  users.groups = {
    anubis.members = [ "nginx" ];
    nginx.members = [ "anubis" ];
  };
  services = {
    nginx = {
      enable = true;

      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;

      virtualHosts = {
        #"vinzenz-lpt2" = {
        #  locations."/" = {
        #    proxyPass = "http://127.0.0.1:3000/";
        #    proxyWebsockets = true;
        #  };
        #
        #  serverAliases = [ "172.23.42.96" ];
        #};

        "vinzenz-lpt2" = {
          locations."/" = {
            proxyPass = "http://unix:" + anubis-domain-socket;
          };
        };

        "vinzenz-lpt2-in-anubis" = {
          root = pkgs.zerforschen-plus-content;
          listen = [
            {
              addr = "unix:" + blog-domain-socket;
            }
          ];
        };
      };
    };

    #networking.firewall = {
    #  allowedTCPPorts = [
    #    80
    #    8001
    #    3000
    #  ];
    #  allowedUDPPorts = [ 2342 ];
    #};

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
}
