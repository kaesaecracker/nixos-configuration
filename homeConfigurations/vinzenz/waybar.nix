{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    playerctl
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "graphical-session.target";
    style = lib.mkAfter (builtins.readFile ./waybar.css);
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        output = [
          "eDP-1"
          "HDMI-A-1"
        ];
        mode = "dock";
        spacing = "8";
        modules-left = [
          "niri/workspaces"
          "tray"
          "niri/window"
        ];
        modules-center = [
          "privacy"
          "clock"
        ];
        modules-right = [
          "mpris"
          #"image"
          "gamemode"

          "temperature"
          "cpu"
          "memory"
          "disk"
          "wireplumber"
          "bluetooth"
          "backlight"
          "network"
          "power-profiles-daemon"
          "battery"
          "idle_inhibitor"
          "group/group-power"
        ];
        "niri/workspaces" = {
          format = "{icon}";
        };

        "niri/window" = {
          separate-outputs = true;
          icon = true;
        };
        network = {
          interface = "wlo1";
          format = "{ifname}";
          format-wifi = " ";
          format-ethernet = "󰈀 ";
          format-linked = "󱘖 ";
          format-disconnected = "󰣽 ";
          tooltip-format = "{ifname} via {gwaddr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname} {ipaddr}/{cidr}";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
        };
        clock = {
          format = "{:%a, %d. %b  %H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              #months = "<span color='#ffead3'><b>{}</b></span>";
              #days = "<span color='#ecc6d9'><b>{}</b></span>";
              #weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              #weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              #weekdays = "<b>{}</b>";
              today = "<span color='#0FBB0F'><b>{}</b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_down";
            on-scroll-down = "shift_up";
          };
        };
        battery = {
          format = "{capacity}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        backlight = {
          device = "intel_backlight";
          format = "{percent}% ";
          on-scroll-down = "light -U 1";
          on-scroll-up = "light -A 1";
        };
        cpu = {
          interval = 1;
          format = "{usage:3}%@{avg_frequency:4}";
        };
        disk = {
          format = "{free}/{total}";
        };
        "group/group-power" = {
          "orientation" = "inherit";
          "drawer" = {
            "transition-duration" = 500;
            "children-class" = "not-power";
            "transition-left-to-right" = false;
          };
          "modules" = [
            "custom/power" # First element is the "group leader" and won't ever be hidden
            "custom/quit"
            "custom/lock"
            "custom/reboot"
          ];
        };
        "custom/quit" = {
          "format" = "󰗼 ";
          "tooltip" = false;
          "on-click" = "niri msg action quit";
          min-width = 20;
        };
        "custom/lock" = {
          "format" = "󰍁 ";
          "tooltip" = false;
          "on-click" = "${lib.getBin config.programs.swaylock.package}/bin/swaylock";
          min-width = 20;
        };
        "custom/reboot" = {
          "format" = "󰜉 ";
          "tooltip" = false;
          "on-click" = "systemctl reboot";
          min-width = 20;
        };
        "custom/power" = {
          "format" = " ";
          "tooltip" = false;
          "on-click" = "systemctl shutdown";
          min-width = 20;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        #image =
        #  let
        #    albumArtScript = pkgs.writeShellScriptBin "album-art.sh" ''
        #      #!${pkgs.bash}/bin/bash
        #      album_art=$(playerctl metadata mpris:artUrl)
        #      if [[ -z $album_art ]]
        #      then
        #         exit
        #      fi
        #      curl -s "''${album_art}" --output "/tmp/cover.jpeg"
        #      echo "/tmp/cover.jpeg"
        #    '';
        #  in
        #  {
        #    exec = "${albumArtScript}/bin/album-art.sh";
        #    interval = 15;
        #    on-click = "playerctl play-pause";
        #  };
        mpris = {
          format = "{title} ";
          tooltip-format = "{player} ({status}) {dynamic}";
        };
        memory = {
          format = "{}% ";
        };
        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };
        wireplumber = {
          format = "{volume}% {icon}";
          format-muted = "";
          format-icons = [
            ""
            ""
            ""
          ];
        };
        temperature = {
          format = "{temperatureC}°C ";
        };
        tray = {
          spacing = 4;
        };
        bluetooth = {
          format = "  {status} ";
          format-connected = "  {device_alias} ";
          format-connected-battery = "  {device_alias} {device_battery_percentage}% ";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        };
      };
    };
  };
}
