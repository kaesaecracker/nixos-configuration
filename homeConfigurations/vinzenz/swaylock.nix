# based on https://codeberg.org/kiara/cfg/src/commit/b9c472acd78c9c08dfe8b6a643c5c82cc5828433/home-manager/kiara/swaylock.nix#
{ pkgs, config, ... }:
{
  config = {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      # https://github.com/jirutka/swaylock-effects/blob/master/swaylock.1.scd
      settings = {
        screenshot = true;
        effect-blur = "9x9";
        effect-vignette = "0.2:0.2";
        fade-in = 0.5;
        font-size = 75;
        indicator-caps-lock = true;
        clock = true;
        indicator-radius = 400;
        show-failed-attempts = true;
        ignore-empty-password = true;
        grace = 3.5;
        indicator-thickness = 20;

        # https://github.com/catppuccin/swaylock/blob/main/themes/mocha.conf
        color = "1e1e2e";
        bs-hl-color = "f5e0dc";
        caps-lock-bs-hl-color = "f5e0dc";
        caps-lock-key-hl-color = "a6e3a1";
        inside-color = "00000000";
        inside-clear-color = "00000000";
        inside-caps-lock-color = "00000000";
        inside-ver-color = "00000000";
        inside-wrong-color = "00000000";
        key-hl-color = "a6e3a1";
        layout-bg-color = "00000000";
        layout-border-color = "00000000";
        layout-text-color = "cdd6f4";
        line-color = "00000000";
        line-clear-color = "00000000";
        line-caps-lock-color = "00000000";
        line-ver-color = "00000000";
        line-wrong-color = "00000000";
        ring-color = "b4befe";
        ring-clear-color = "f5e0dc";
        ring-caps-lock-color = "fab387";
        ring-ver-color = "89b4fa";
        ring-wrong-color = "eba0ac";
        separator-color = "00000000";
        text-color = "cdd6f4";
        text-clear-color = "f5e0dc";
        text-caps-lock-color = "fab387";
        text-ver-color = "89b4fa";
        text-wrong-color = "eba0ac";
      };
    };

    services.swayidle = {
      enable = true;
      systemdTarget = "graphical-session.target";
      timeouts = [
        {
          timeout = 60;
          command = "${config.programs.swaylock.package}/bin/swaylock";
        }
        {
          timeout = 60 * 10;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.playerctl}/bin/playerctl pause; ${config.programs.swaylock.package}/bin/swaylock";
        }
        {
          event = "lock";
          command = "${config.programs.swaylock.package}/bin/swaylock";
        }
      ];
    };
  };
}
