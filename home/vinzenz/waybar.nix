{ pkgs, device, ... }:
{
  config.programs.waybar = {
    enable = true;
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
          "niri/window"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "tray"
          "mpd"

          "temperature"
          "cpu"

          "disk"
          "backlight"
          "pulseaudio"
          "bluetooth"
          "memory"
          "network"
          "battery"
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
        };
        cpu = {
          "interval" = 1;
          "format" =
            "{usage:3}%@{avg_frequency:4} "
            + (builtins.getAttr device {
              "vinzenz-lpt2" =
                "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}{icon8}{icon9}{icon10}{icon11}{icon12}{icon13}{icon14}{icon15}{icon16}{icon17}{icon18}{icon19}";
            })
            + " ";
          "format-icons" = [
            "<span color='#69ff94'>▁</span>"
            "<span color='#2aa9ff'>▂</span>"
            "<span color='#f8f8f2'>▃</span>"
            "<span color='#f8f8f2'>▄</span>"
            "<span color='#ffffa5'>▅</span>"
            "<span color='#ffffa5'>▆</span>"
            "<span color='#ff9977'>▇</span>"
            "<span color='#dd532e'>█</span>"
          ];
        };
      };
    };
  };
}
