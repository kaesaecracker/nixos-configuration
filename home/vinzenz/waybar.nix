{ pkgs, device, ... }:
{
  home.packages = with pkgs; [
    waybar
    playerctl
  ];

  programs.cava.enable = true;

  programs.waybar = {
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
          "tray"
          "niri/window"
        ];
        modules-center = [
          "privacy"
          "clock"
        ];
        modules-right = [
          "mpris"
          "image"
          "cava"
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
          #"group/group-power"
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
          interval = 1;
          format =
            "{usage:3}%@{avg_frequency:4} "
            + (builtins.getAttr device {
              "vinzenz-lpt2" =
                "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}{icon8}{icon9}{icon10}{icon11}{icon12}{icon13}{icon14}{icon15}{icon16}{icon17}{icon18}{icon19}";
            })
            + " ";
          format-icons = [
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
        cava = {
          framerate = 15;
          autosens = 1;
          method = "pipewire";
          sleep_timer = 3;
          source = "auto";
          bar_delimiter = 0;
          bars = 12;
          input_delay = 2;
          hide_on_silence = true;
          format-icons = [
            "<span font-family='monospace'>▁</span>"
            "<span font-family='monospace'>▂</span>"
            "<span font-family='monospace'>▃</span>"
            "<span font-family='monospace'>▄</span>"
            "<span font-family='monospace'>▅</span>"
            "<span font-family='monospace'>▆</span>"
            "<span font-family='monospace'>▇</span>"
            "<span font-family='monospace'>█</span>"
          ];
          actions = {
            "on-click-right" = "mode";
          };
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
          "format" = "󰗼";
          "tooltip" = false;
          "on-click" = "hyprctl dispatch exit";
          min-width = 20;
        };
        "custom/lock" = {
          "format" = "󰍁";
          "tooltip" = false;
          "on-click" = "swaylock";
        };
        "custom/reboot" = {
          "format" = "󰜉";
          "tooltip" = false;
          "on-click" = "reboot";
        };
        "custom/power" = {
          "format" = "";
          "tooltip" = false;
          "on-click" = "shutdown now";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        image =
          let
            albumArtScript = pkgs.writeShellScriptBin "album-art.sh" ''
              #!${pkgs.bash}/bin/bash
              album_art=$(playerctl metadata mpris:artUrl)
              if [[ -z $album_art ]]
              then
                 exit
              fi
              curl -s "''${album_art}" --output "/tmp/cover.jpeg"
              echo "/tmp/cover.jpeg"
            '';
          in
          {
            exec = "${albumArtScript}/bin/album-art.sh";
            interval = 15;
            on-click = "playerctl play-pause";
          };
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
