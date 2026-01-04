let
  headscale-port = 8668;
in
{
  services = {
    headscale = {
      enable = true;
      address = "localhost";
      port = headscale-port;
      settings = {
        server_url = "https://uplink.darkest.space/";
        dns = {
          override_local_dns = false;
          base_domain = "high-gravity.space";
        };
      };
    };
    nginx.virtualHosts."uplink.darkest.space" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:${builtins.toString headscale-port}";
        proxyWebsockets = true;
      };
    };
  };
}
