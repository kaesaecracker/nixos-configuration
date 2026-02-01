{ pkgs, ... }:
let
  hass-image = "ghcr.io/home-assistant/home-assistant:stable";
  hass-service = "podman-homeassistant";
in
{
  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      image = hass-image;
      hostname = "hass.lan";
      serviceName = hass-service;
      volumes = [ "home-assistant:/config" ];
      environment.TZ = "Europe/Berlin";
      extraOptions = [ "--network=host" ];
    };
  };

  systemd = {
    timers.update-hass = {
      timerConfig = {
        Unit = "update-hass.service";
        OnCalendar = "Sun 02:00";
      };
      wantedBy = [ "timers.target" ];
    };

    services.update-hass = {
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScriptBin "update-hass" ''
          podman pull ${hass-image};
          systemctl restart ${hass-service};
        '';
      };
    };
  };

  services = {
    mosquitto = {
      enable = true;
    };

    nginx = {
      enable = true;

      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;

      # TODO: add ssl
      # TODO: add pam auth

      virtualHosts."hass.lan" = {
        locations."/" = {
          proxyPass = "localhost:8123";
        };
      };
    };
  };
}
