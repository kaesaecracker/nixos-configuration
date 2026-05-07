{ self, ... }:
{
  config = {
    boot.enableContainers = true;
    virtualisation.containers.enable = true;

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
  };
}
