{
  pkgs,
  ...
}:
{
  environment.packages = with pkgs; [
    nano
    hostname
    zsh
    openssh
    which
    curl
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  system.stateVersion = "24.05";
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  time.timeZone = "Europe/Berlin";
}
