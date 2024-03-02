{pkgs, ...}: {
  imports = [
    (import ./modules {
      hostName = "hetzner-vpn1";
      enableHomeManager = false;
    })
  ];

  config = {
    my = {
      enabledUsers = ["ronja" "vinzenz"];
      tailscale.enable = true;
    };

    users.users.root.openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICdYqY3Y1/f1bsAi5Qfyr/UWuX9ixu96IeAlhoQaJkbf''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY vinzenz-pixel-JuiceSSH''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1CRn4yYTL4XUdCebE8Z4ZeuMujBjorTdWifg911EOv vinzenz-pc2 home roaming''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDNpLDmctyqGpow/ElQvdhY4BLBPS/sigDJ1QEcC7wC vinzenz-lpt2-roaming''
    ];

    security.acme = {
      acceptTerms = true;
      defaults.email = "acme@zerforschen.plus";
    };

    security.pam.services.nginx.setEnvironment = false;
    systemd.services.nginx.serviceConfig = {
      SupplementaryGroups = ["shadow"];
    };

    services.nginx = {
      enable = true;
      additionalModules = [pkgs.nginxModules.pam];

      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;

      virtualHosts = {
        "vscode.services.zerforschen.plus" = {
          addSSL = true;
          enableACME = true;
          locations."/" = {
            extraConfig = ''
              # bind to tailscale ip
              proxy_bind 100.88.118.60;
              auth_pam  "Password Required";
              auth_pam_service_name "nginx";
            '';
            proxyPass = "http://vinzenz-lpt2:8542/"; #tailscale magic dns
            proxyWebsockets = true;
          };
        };

        "preon-app.services.zerforschen.plus" = {
          enableACME = true;
          addSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:3000/";
          };
        };

        "preon-api.services.zerforschen.plus" = {
          enableACME = true;
          addSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:3002/";
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = [80 443];
  };
}
