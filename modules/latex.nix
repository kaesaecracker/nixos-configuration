{ pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      fontconfig
      texliveFull
      texstudio
    ];
  };
}
