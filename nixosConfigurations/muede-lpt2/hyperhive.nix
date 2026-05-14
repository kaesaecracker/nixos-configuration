{ hyperhive, ... }:
{
  imports = [ hyperhive.nixosModules.hive-c0re ];

  config.services.hive-c0re.enable = true;
}
