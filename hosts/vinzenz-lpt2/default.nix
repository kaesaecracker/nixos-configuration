{...}: {
  imports = [
    ./hardware.nix
    ./environment.nix
  ];
  config = {
    networking.hostName = "vinzenz-lpt2";
  };
}
