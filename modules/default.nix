{
  config,
  pkgs,
  modulesPath,
  lib,
  ...
}:
with lib; let
  cfg = config.my;
in {
  imports = [
    ./home
    ./desktop
    ./i18n.nix
    ./nixpkgs.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    networking = {
      # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
      # wireless.userControlled.enable = true;

      # Enable networking
      networkmanager.enable = true;

      firewall.enable = true;
    };

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
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
