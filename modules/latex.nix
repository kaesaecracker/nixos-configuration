{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      fontconfig
      texliveFull
      texstudio
    ];
  };
}
