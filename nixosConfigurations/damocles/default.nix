{ pkgs, self, ... }:
{
  imports = [ ./android-dev.nix ];

  nixpkgs.overlays = [ self.overlays.unstable-packages ];

  boot.isContainer = true;

  allowedUnfreePackages = [ "claude-code" ];

  environment.systemPackages = with pkgs; [
    unstable.claude-code
    git
    python3
    coreutils-full
    gawk
    gnugrep
  ];

  users.users.muede = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  security.sudo.wheelNeedsPassword = false;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];
  };
}
