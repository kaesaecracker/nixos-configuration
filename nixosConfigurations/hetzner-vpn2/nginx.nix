{
  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@zerforschen.plus";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
