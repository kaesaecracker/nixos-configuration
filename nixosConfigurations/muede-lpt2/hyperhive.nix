{ hyperhive, ... }:
{
  imports = [
    hyperhive.nixosModules.hive-c0re
    hyperhive.nixosModules.hive-forge
  ];

  config.services.hive-c0re.enable = true;
  config.services.hive-forge.enable = true;
}
