{ config, lib, ... }:
let
  srv = config.services.forgejo.settings.server;
in
{
  services.forgejo = {
    enable = true;
    database.type = "sqlite3";
    lfs.enable = true;

    settings = {
      server = {
        DOMAIN = "forge.darkest.space";
        ROOT_URL = "https://${srv.DOMAIN}/";
        HTTP_PORT = 3000;
        SSH_PORT = lib.head config.services.openssh.ports;
      };
      service.DISABLE_REGISTRATION = true;
      session.COOKIE_SECURE = true;
    };
  };

  services.openssh.enable = true;
}
