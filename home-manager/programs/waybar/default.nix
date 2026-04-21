{
  lib,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    # Based on: https://github.com/Pipshag/dotfiles_nord
    style = ./style.css;
    settings = [
      {
        bluetooth = {
          format = "{icon}";
          format-icons = {
            disabled = "<span alpha='50%'>BT</span>";
            enabled = "BT";
          };
          interval = 30;
          on-click = lib.getExe' pkgs.blueman "blueman-manager";
        };
        clock = {
          format = "{:%H:%M %d.%m.}";
          format-alt = "{:%Y-%m-%dT%H:%M:%S%z}";
          tooltip = false;
        };
        cpu = {
          align = 1;
          format = "<span alpha='50%'>{usage}%</span>";
          interval = 2;
          justify = "right";
          max-length = 40;
          tooltip = false;
        };
        "cpu#cores" = {
          align = 1;
          format = " {icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}{icon8}{icon9}{icon10}{icon11}{icon12}{icon13}{icon14}{icon15}{icon16}{icon17}{icon18}{icon19}";
          format-icons = [
            "▁"
            "▂"
            "▃"
            "▄"
            "▅"
            "▆"
            "▇"
            "█"
          ];
          interval = 2;
          justify = "right";
          tooltip = false;
        };
        "custom/gpu" = {
          align = 1;
          escape = false;
          exec = lib.getExe (pkgs.writeShellApplication {
            name = "waybar-gpu-status";
            runtimeInputs = with pkgs; [coreutils gawk];
            text = ''
              if ! command -v nvidia-smi >/dev/null 2>&1; then
                echo "GPU N/A"
                exit 0
              fi

              nvidia-smi \
                --query-gpu=clocks.current.graphics,memory.used,memory.total,utilization.gpu \
                --format=csv,noheader,nounits |
                head -n1 |
                awk -F", " '{
                  printf "<span alpha=\"50%%\">%s%%</span> %.1fGHz %.1f<span alpha=\"50%%\">/</span>%.0fGi <span alpha=\"50%%\">GPU</span>\n", $4, $1/1000, $2/1024, $3/1024
                }'
            '';
          });
          interval = 2;
          justify = "right";
          max-length = 40;
          tooltip = false;
        };
        disk = {
          align = 1;
          format = "<span alpha='50%'>{percentage_used}%</span> {specific_used:0.1f}<span alpha='50%'>/</span>{specific_total:0.1f}Ti <span alpha='50%'>{path}</span>";
          interval = 30;
          justify = "right";
          path = "/";
          tooltip = false;
          unit = "TiB";
        };
        exclusive = true;
        gtk-layer-shell = true;
        height = 32;
        spacing = 8;
        "hyprland/workspaces" = {
          icon-size = 20;
          # NOTE: Using r±1 instead of e±1 to allow switching to a new empty workspace.
          on-scroll-down = "${lib.getExe' pkgs.hyprland "hyprctl"} dispatch workspace r-1";
          on-scroll-up = "${lib.getExe' pkgs.hyprland "hyprctl"} dispatch workspace r+1";
          spacing = 16;
        };
        layer = "top";
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;
        memory = {
          align = 1;
          format = "<span alpha='50%'>{percentage}%</span> {used:0.1f}<span alpha='50%'>/</span>{total:0.0f}Gi <span alpha='50%'>RAM</span>";
          interval = 10;
          justify = "right";
          max-length = 40;
          tooltip = false;
        };
        "group/cpu-group" = {
          modules = [
            "cpu"
            "cpu#cores"
            "temperature"
          ];
          orientation = "inherit";
        };
        mode = "dock";
        modules-center = [];
        modules-left = [
          "hyprland/workspaces"
          "wlr/taskbar"
          "hyprland/window"
        ];
        modules-right = [
          "group/cpu-group"
          "memory"
          "custom/gpu"
          "disk"
          "pulseaudio"
          "bluetooth"
          "network"
          "clock"
          "tray"
        ];
        network = {
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          format-disconnected = "OFF";
          format-ethernet = "{ipaddr}<span alpha='50%'>/{cidr}</span> <span alpha='50%'>ETH</span>";
          format-linked = "{ifname} (No IP)";
          format-wifi = "WIFI {essid}";
          tooltip-format-ethernet = "{ifname} ↑ {bandwidthUpBits} ↓ {bandwidthDownBits}";
          tooltip-format-wifi = "WIFI {ifname} @ {essid}\nIP: {ipaddr}\nStrength: {signalStrength}%\nFreq: {frequency}MHz\n↑ {bandwidthUpBits} ↓ {bandwidthDownBits}";
        };
        passthrough = false;
        position = "bottom";
        pulseaudio = {
          format-bluetooth-muted = "<span alpha='60%'>VOL</span> <span alpha='60%'>MUT</span>";
          format-icons = {
            car = "VOL";
            default = [
              "VOL"
              "VOL"
              "VOL"
            ];
            hands-free = "VOL";
            headphone = "VOL";
            headset = "VOL";
            phone = "VOL";
            portable = "VOL";
          };
          format-muted = "<span alpha='60%'>{icon}</span> <span alpha='60%'>MUT</span>";
          format-source = "MIC";
          format-source-muted = "<span alpha='60%'>MUT</span>";
          max-volume = 120;
          on-click = lib.getExe pkgs.pavucontrol;
          on-click-right = "${lib.getExe' pkgs.pulseaudio "pactl"} set-source-mute @DEFAULT_SOURCE@ toggle";
          scroll-step = 10;
          format = "<span alpha='60%'>{volume}%</span> <span alpha='60%'>{icon}</span> {format_source}";
          format-bluetooth = "<span alpha='60%'>{volume}%</span> <span alpha='60%'>{icon}</span> {format_source}";
          tooltip = false;
        };
        start_hidden = false;
        temperature = {
          align = 1;
          critical-threshold = 75;
          format = " {temperatureC}°C <span alpha='50%'>CPU</span>";
          hwmon-path-abs = "/sys/devices/platform/coretemp.0/hwmon";
          input-filename = "temp2_input";
          justify = "right";
          tooltip = false;
        };
        tray = {
          icon-size = 18;
          spacing = 5;
        };
        "hyprland/window" = {
          format = "{}";
          max-length = 120;
          tooltip = false;
        };
        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 20;
          ignore-list = [];
          on-click = "activate";
          on-click-middle = "close";
          spacing = 0;
          tooltip-format = "{title}";
        };
      }
    ];
  };
}
