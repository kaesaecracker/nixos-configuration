{
  lib,
  config,
  pkgs,
  thisDevice,
  ...
}:
{
  options.my.openssh.enable = lib.mkEnableOption "OpenSSH server";

  config = lib.mkIf config.my.openssh.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    # On desktops, hold a systemd sleep inhibitor while SSH connections are active
    security.pam.services.sshd.rules.session.ssh-inhibit = lib.mkIf (thisDevice.isDesktop or false) {
      order = 10000;
      control = "optional";
      modulePath = "${pkgs.pam}/lib/security/pam_exec.so";
      args = [
        "quiet"
        "${pkgs.writeShellScript "ssh-inhibit-pam" ''
          PIDFILE="/run/ssh-inhibitor-''${PPID}.pid"
          case "''${PAM_TYPE:-}" in
            open)
              ${pkgs.systemd}/bin/systemd-inhibit \
                --what=sleep \
                --who=sshd \
                --why="SSH session active" \
                --mode=block \
                sleep infinity &
              echo $! > "$PIDFILE"
              ;;
            close)
              if [ -f "$PIDFILE" ]; then
                kill "$(cat "$PIDFILE")" 2>/dev/null || true
                rm -f "$PIDFILE"
              fi
              ;;
          esac
        ''}"
      ];
    };
  };
}
