{ config, ... }:
let
  srv = config.services.forgejo.settings.server;
in
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@darkest.space";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;

    virtualHosts.${srv.DOMAIN} = {
      enableACME = true;
      forceSSL = true;
      extraConfig = ''
        client_max_body_size 512M;
      '';
      locations."/".proxyPass = "http://127.0.0.1:${toString srv.HTTP_PORT}";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
