{
  config,
  pkgs,
  ...
}: let
  cfg = config.my;
  helpers = import ../helpers;
in {
  imports = [
    ./home
    ./desktop
    ./i18n.nix
    ./nixpkgs.nix
  ];

  config = {
    networking = {
      networkmanager.enable = true;
      firewall.enable = true;
    };

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      settings = {
        # PermitRootLogin = "no"; # this is managed through authorized keys
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    systemd.extraConfig = ''
      DefaultTimeoutStopSec=12s
    '';

    programs = {
      zsh.enable = true;

      git = {
        enable = true;
        package = pkgs.gitFull;
      };
    };

    environment = {
      pathsToLink = ["/share/zsh"];

      systemPackages = with pkgs; [
        lm_sensors
        tldr
        ncdu
      ];
    };
  };
}
