{ self, ... }:
{
  imports = [
    ./hardware.nix
  ];

  config = {
    my = {
      # keep-sorted start
      intelGraphics.enable = true;
      muedeDesktopSettings.enable = true;
      podman.enable = true;
      secureBoot.enable = true;
      steam.enable = true;
      users.muede.enable = true;
      wineGaming.enable = true;
      # keep-sorted end
    };

    nix.settings.extra-platforms = [
      "aarch64-linux"
      "i686-linux"
    ];

    services.xserver.xkb = {
      # Configure keymap in X11
      layout = "de";
      variant = "";
    };

    # Configure console keymap
    console.keyMap = "de";

    users.users.muede.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJUpbpB3KEKVoKWsKoar9J4RNah8gmQoSH6jQEw5dY pixel-JuiceSSH"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1CRn4yYTL4XUdCebE8Z4ZeuMujBjorTdWifg911EOv pc2 home roaming"
    ];

    programs = {
      adb.enable = true;
      light = {
        enable = true;
        brightnessKeys = {
          enable = true;
          step = 5;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      8776
      1337
    ];

    services.servicepoint-tanks = {
      enable = false;
      urls = [
        "http://localhost:5666"
        "http://localhost:5667"
      ];
    };
    nixpkgs.config.permittedInsecurePackages = [
      "mbedtls-2.28.10"
    ];

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    containers.damocles = {
      autoStart = false;
      privateNetwork = false;
      path = self.nixosConfigurations.damocles.config.system.build.toplevel;
      bindMounts."/etc/nix/distributed-build-key" = {
        hostPath = "/etc/nix/distributed-build-key";
        isReadOnly = true;
      };
      bindMounts."/persist/damocles-ssh" = {
        hostPath = "/persist/damocles-ssh";
        isReadOnly = true;
      };
      bindMounts."/persist/damocles-lab" = {
        hostPath = "/persist/damocles-lab";
        isReadOnly = false;
      };
    };

    containers.damocles-lab = {
      autoStart = false;
      privateNetwork = false;
      path = self.nixosConfigurations.damocles-lab.config.system.build.toplevel;
      bindMounts."/etc/nix/distributed-build-key" = {
        hostPath = "/etc/nix/distributed-build-key";
        isReadOnly = true;
      };
      bindMounts."/workspace" = {
        hostPath = "/persist/damocles-lab";
        isReadOnly = false;
      };
      bindMounts."/persist/damocles-ssh" = {
        hostPath = "/persist/damocles-ssh";
        isReadOnly = true;
      };
    };

    # Global DefaultTimeoutStopSec is 10s (modern-desktop.nix), which kills systemd-nspawn
    # before it finishes halting, leaving cgroups busy and breaking restarts.
    systemd.services."container@damocles".serviceConfig = {
      TimeoutStopSec = "60s";
      # After a SIGKILL of nspawn, the kernel needs a moment to reap its cgroups.
      # Without this, the immediate restart attempt fails with "Device or resource busy".
      RestartSec = "5s";
    };

    systemd.services."container@damocles-lab".serviceConfig = {
      TimeoutStopSec = "60s";
      RestartSec = "5s";
    };

    boot.enableContainers = true;
    virtualisation.containers.enable = true;
  };
}
