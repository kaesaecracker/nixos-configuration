modulesCfg: {
  config,
  pkgs,
  lib,
  ...
}: let
  enableHomeManager = modulesCfg.enableHomeManager;
in {
  options.my = {
    modulesCfg.enableHomeManager = lib.mkEnableOption "enable home manager";
    enabledUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };
  };

  imports =
    [
      ./vinzenz.nix
      ./ronja.nix
    ]
    ++ lib.optionals enableHomeManager [
      ./home-manager.nix
    ];
}
