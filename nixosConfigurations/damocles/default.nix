{ pkgs, ... }:
{
  boot.isContainer = true;

  allowedUnfreePackages = [ "claude-code" ];

  environment.systemPackages = with pkgs; [
    unstable.claude-code
    git
  ];

  users.users.muede = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  security.sudo.wheelNeedsPassword = false;
}
