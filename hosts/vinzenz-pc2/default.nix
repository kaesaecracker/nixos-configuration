{...}: {
  imports = [
    ./hardware.nix
    ./environment.nix
  ];
  config = {
    networking.hostName = "vinzenz-pc2";
  };
}
