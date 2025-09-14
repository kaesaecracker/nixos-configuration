{ nixosModules, ... }:
{
  imports = [ nixosModules.allowed-unfree-list ];

  hardware.steam-hardware.enable = true;

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = false;
    };
    gamemode.enable = true;
  };

  # steam network transfer
  networking.firewall = {
    allowedUDPPorts = [ 3478 ];
    allowedTCPPorts = [ 24070 ];

    allowedTCPPortRanges = [
      {
        from = 27015;
        to = 27050;
      }
    ];

    allowedUDPPortRanges = [
      {
        from = 4379;
        to = 4380;
      }
      {
        from = 27000;
        to = 27100;
      }
    ];
  };

  allowedUnfreePackages = [
    "steam"
    "steam-original"
    "steam-run"
    "steam-unwrapped"
  ];
}
