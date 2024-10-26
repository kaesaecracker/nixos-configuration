{...}: {
  imports = [
    ./hardware.nix
    ./environment.nix
  ];
  config = {
    networking.hostName = "vinzenz-lpt2";

    nix.settings.extra-platforms = ["aarch64-linux"];
  };
}
