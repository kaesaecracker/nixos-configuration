{ pkgs, lib, ... }:
{
  # https://github.com/nix-community/lanzaboote/blob/70be03ab23d0988224e152f5b52e2fbf44a6d8ee/docs/QUICK_START.md
  # To enroll:
  # 1. sudo sbctl create-keys
  # 2. import this module, rebuild
  # 3. Put Secure Boot in Setup mode
  # 4. sudo sbctl verify
  # 5. sudo sbctl enroll-keys --microsoft
  # 6, reboot
  # 7. sudo sbctl status

  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
