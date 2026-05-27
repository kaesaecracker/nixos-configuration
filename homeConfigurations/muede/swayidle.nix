{ pkgs, ... }:
{
  services.swayidle =
    let
      lock-command = "${pkgs.systemd}/bin/loginctl lock-session";
    in
    {
      enable = true;
      systemdTargets = [ "graphical-session.target" ];
      timeouts = [
        {
          timeout = 30;
          command = lock-command;
        }
        {
          timeout = 60 * 10;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = {
        before-sleep = "${pkgs.playerctl}/bin/playerctl pause; ${lock-command}";
      };
    };
}
