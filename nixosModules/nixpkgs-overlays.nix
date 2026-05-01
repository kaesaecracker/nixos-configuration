{
  lib,
  config,
  self,
  ...
}:
{
  options.my.overlays = {
    enableAll = lib.mkEnableOption "all nixpkgs overlays";
  }
  // lib.mapAttrs (_: _: {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  }) self.overlays;

  config = lib.mkMerge (
    [
      {
        my.overlays = lib.mapAttrs (_: _: {
          enable = lib.mkDefault config.my.overlays.enableAll;
        }) self.overlays;
      }
    ]
    ++ lib.mapAttrsToList (
      name: overlay:
      lib.mkIf config.my.overlays.${name}.enable {
        nixpkgs.overlays = [ overlay ];
      }
    ) self.overlays
  );
}
