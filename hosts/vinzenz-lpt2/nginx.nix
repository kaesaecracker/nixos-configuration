_: {
  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;

    virtualHosts = {
      "vinzenz-lpt2" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000/";
          proxyWebsockets = true;
        };

        serverAliases = [ "172.23.42.96" ];
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      8001
      3000
    ];
    allowedUDPPorts = [ 2342 ];
  };
}
