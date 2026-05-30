{ hyperhive, ... }:
{
  imports = [ hyperhive.nixosModules.default ];

  config.services.hyperhive = {
    enable = true;
    domain = "pr1ma.darkest.space";
    matrix = {
      enable = true;
      gui.enable = true;
    };
  };
}
