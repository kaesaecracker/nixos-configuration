{ hyperhive, ... }:
{
  imports = [ hyperhive.nixosModules.default ];

  config.services.hyperhive = {
    enable = true;
  };
}
