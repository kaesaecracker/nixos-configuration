{
  config,
  lib,
  pkgs,
  ...
}:
let
  srv = config.services.forgejo.settings.server;

  catppuccinThemes = pkgs.fetchzip {
    url = "https://github.com/catppuccin/gitea/releases/download/v1.0.2/catppuccin-gitea.tar.gz";
    hash = "sha256-rZHLORwLUfIFcB6K9yhrzr+UwdPNQVSadsw6rg8Q7gs=";
    stripRoot = false;
  };

  themeNames = lib.pipe (builtins.readDir catppuccinThemes) [
    (lib.filterAttrs (n: t: t == "regular" && lib.hasSuffix ".css" n))
    builtins.attrNames
    (map (n: lib.removePrefix "theme-" (lib.removeSuffix ".css" n)))
  ];
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
      ui.THEMES = lib.concatStringsSep "," ([ "forgejo-auto" "forgejo-light" "forgejo-dark" ] ++ themeNames);
    };
  };

  systemd.tmpfiles.settings."10-forgejo-catppuccin" =
    let
      dirOwn = {
        user = config.services.forgejo.user;
        group = config.services.forgejo.group;
        mode = "0755";
      };
    in
    {
      "${config.services.forgejo.customDir}/public".d = dirOwn;
      "${config.services.forgejo.customDir}/public/assets".d = dirOwn;
      "${config.services.forgejo.customDir}/public/assets/css"."L+" = {
        argument = "${catppuccinThemes}";
      };
    };

  services.openssh.enable = true;
}
