{
  pkgs,
  system,
  inputs,
  ...
}:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@zerforschen.plus";
  };

  security.pam.services.nginx.setEnvironment = false;
  systemd.services.nginx.serviceConfig = {
    SupplementaryGroups = [ "shadow" ];
  };

  services.nginx = {
    enable = true;
    additionalModules = [ pkgs.nginxModules.pam ];

    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;

    virtualHosts = {
      "zerforschen.plus" = {
        #addSSL = true;
        #enableACME = true;
        root = inputs.zerforschen-plus.packages."${pkgs.system}".zerforschen-plus-content;
      };
    };
  };

  #networking.firewall.allowedTCPPorts = [
  #  80
  #  443
  #];
}
