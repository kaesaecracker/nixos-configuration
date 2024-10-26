{...}: {
  imports = [
    ./hardware.nix
    ./environment.nix
  ];
  config = {
    networking.hostName = "hetzner-vpn1";
  };
}
