{ pkgs, ... }:
{
  services.swayidle =
    let
      lock-command = "${pkgs.systemd}/bin/loginctl lock-session";
    in
    {
      enable = true;
      systemdTarget = "graphical-session.target";
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
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.playerctl}/bin/playerctl pause; ${lock-command}";
        }
      ];
    };
}
