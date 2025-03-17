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
        grace = 2;
        color = "000000";
        indicator-thickness = 20;
      };
    };

    services.swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 60;
          command = "${config.programs.swaylock.package}/bin/swaylock";
        }
        #{
        #  timeout = 90;
        #  command = "${pkgs.systemd}/bin/systemctl suspend";
        #}
      ];
    };
  };
}
