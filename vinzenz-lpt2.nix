{pkgs, ...}: {
  imports = [
    (import ./modules {
      hostName = "vinzenz-lpt2";
      enableHomeManager = true;
    })
  ];

  config = {
    my = {
      enabledUsers = ["vinzenz" "ronja"];
      tailscale.enable = true;
      desktop = {
        enableGnome = true;
        enableGaming = true;
        enablePrinting = true;
      };
      buildtools = {
        dotnet = true;
        #objective-c = true;
      };

      allowUnfreePackages = [
        "rider"
        "clion"
        "pycharm-professional"
      ];
    };

    environment.systemPackages = with pkgs; [anydesk];

    virtualisation.podman = {
      enable = true;
    };

    users.users.vinzenz.openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY vinzenz-pixel-JuiceSSH''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1CRn4yYTL4XUdCebE8Z4ZeuMujBjorTdWifg911EOv vinzenz-pc2 home roaming''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALWKm+d6KL6Vl3grPOcGouiNTkvdhXuWJmcrdEBY2nw ronja-ssh-host-key''
    ];

    users.users.ronja.openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALWKm+d6KL6Vl3grPOcGouiNTkvdhXuWJmcrdEBY2nw ssh-host-key''
    ];

    # TODO: move to own module
    services.openvscode-server = {
      enable = true;
      telemetryLevel = "off";
      port = 8542;
      host = "127.0.0.1";
      extraPackages = with pkgs; [nodejs];
    };

    services.nginx = {
      enable = true;
      virtualHosts = {
        "vscode" = {
          serverName = "vinzenz-lpt2";
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:8542";
              extraConfig = ''
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "Upgrade";
                proxy_set_header Host $host;
              '';
            };
          };

          listen = [
            {
              addr = "0.0.0.0";
              port = 5000;
              ssl = true;
            }
          ];

          serverAliases = ["localhost" "vinzenz-lpt2.lan"];
          addSSL = true;
          sslCertificateKey = "/etc/nginx-secrets/nginx-selfsigned.key";
          sslCertificate = "/etc/nginx-secrets/nginx-selfsigned.crt";
        };
        "app" = {
          serverName = "vinzenz-lpt2";
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:3000/";
            };
          };

          listen = [
            {
              addr = "0.0.0.0";
              port = 5001;
              ssl = true;
            }
          ];

          serverAliases = ["localhost" "vinzenz-lpt2.lan"];
          addSSL = true;
          sslCertificateKey = "/etc/nginx-secrets/nginx-selfsigned.key";
          sslCertificate = "/etc/nginx-secrets/nginx-selfsigned.crt";
        };
        "api" = {
          serverName = "vinzenz-lpt2";
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:3002/";
            };
          };

          listen = [
            {
              addr = "0.0.0.0";
              port = 5002;
              ssl = true;
            }
          ];

          serverAliases = ["localhost" "vinzenz-lpt2.lan"];
          addSSL = true;
          sslCertificateKey = "/etc/nginx-secrets/nginx-selfsigned.key";
          sslCertificate = "/etc/nginx-secrets/nginx-selfsigned.crt";
        };
      };
    };

    networking.firewall.allowedTCPPortRanges = [
      {
        from = 5000;
        to = 5005;
      }
    ];
  };
}
