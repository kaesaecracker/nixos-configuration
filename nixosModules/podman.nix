{ lib, config, ... }:
{
  options.my.podman.enable = lib.mkEnableOption "Podman container runtime";

  config = lib.mkIf config.my.podman.enable {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        autoPrune.enable = true;
      };
    };
  };
}
