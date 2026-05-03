{
  pkgs,
  lib,
  ...
}:
{

  my = {
    allowedUnfreePackages = [ "claude-code" ];
    overlays.unstable.enable = true;
  };

  environment.systemPackages = with pkgs; [
    unstable.claude-code
    git
    python3
    coreutils-full
    gawk
    gnugrep
    curl
  ];

  boot.isContainer = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];
  };

  # Container shares host network namespace (privateNetwork = false), so the
  # host's tailscale already covers this. Running a second tailscaled in the
  # same netns fights over routing and breaks connectivity after sleep/wake.
  services.tailscale.enable = lib.mkForce false;
  networking.firewall.checkReversePath = lib.mkForce "strict";

  users.users.muede = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  security.sudo.wheelNeedsPassword = false;
}
