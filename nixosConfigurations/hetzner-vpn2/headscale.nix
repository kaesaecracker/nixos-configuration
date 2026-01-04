let
  headscale-port = 8668;
in
{
  # sudo tailscale up --reset --force-reauth --login-server https://uplink.darkest.space --operator=$USER

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
        derp = {
          server = {
            enabled = true;
            verify_clients = true;
            stun_listen_addr = "0.0.0.0:3478";
            ipv4 = "78.46.242.90";
            ipv6 = "2a01:4f8:c013:65dd::1";
          };
          urls = [ ];
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

  # for DERP
  networking.firewall.allowedUDPPorts = [ 3478 ];
}
