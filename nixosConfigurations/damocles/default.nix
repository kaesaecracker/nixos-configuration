{ pkgs, ... }:
{
  imports = [
    ./android-dev.nix
    ./claude-container.nix
  ];

  environment.systemPackages = with pkgs; [
    cargo
    rustc
    clippy
    gh
  ];
}
