{
  lib,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    style = ./style.css;
    # Based on:
    # https://github.com/TheFrankyDoll/win10-style-waybar
    settings.mainbar = {
      layer = "bottom";
      position = "bottom";
      mod = "dock";
      exclusive = true;
      gtk-layer-shell = true;
      margin-bottom = -1;
      passthrough = false;
      height = 48;
      modules-left = [
        "custom/os-button"
        "hyprland/workspaces"
        "wlr/taskbar"
      ];
      modules-center = [];
      modules-right = [
        "tray"
        "pulseaudio"
        "cpu"
        "temperature"
        "memory"
        "disk"
        "network"
        "battery"
        "clock"
      ];
      "hyprland/workspaces" = {
        icon-size = 24;
        spacing = 16;
        on-scroll-up = "hyprctl dispatch workspace r+1";
        on-scroll-down = "hyprctl dispatch workspace r-1";
      };
      "custom/os-button" = let
        menu = pkgs.writeShellApplication {
          name = "waybar-os-button";
          runtimeInputs = with pkgs; [wofi];
          text = ''
            wofi --show drun --allow-images --allow-markup --hide-scroll --no-actions --columns 4 --lines 12
          '';
        };
      in {
        format = "";
        on-click = pkgs.lib.getExe menu;
        tooltip = false;
      };
      cpu = {
        interval = 5;
        format = "{usage}%| ";
        max-length = 10;
        tooltip = false;
      };
      temperature = {
        hwmon-path-abs = "/sys/devices/platform/coretemp.0/hwmon";
        input-filename = "temp2_input";
        critical-threshold = 75;
        tooltip = false;
        format-critical = "({temperatureC}°C)";
        format = "({temperatureC}°C)";
      };
      disk = {
        interval = 30;
        format = "{percentage_used}%|󰋊";
        path = "/";
        tooltip = false;
        unit = "GB";
      };
      memory = {
        interval = 10;
        format = "{percentage}%| ";
        max-length = 10;
        tooltip = false;
      };
      "wlr/taskbar" = {
        format = "{icon}";
        icon-size = 24;
        spacing = 0;
        on-click-middle = "close";
        tooltip-format = "{title}";
        ignore-list = [];
        on-click = "activate";
      };
      tray = {
        icon-size = 18;
        spacing = 3;
      };
      clock = {
        format = "      {:%R\n %d.%m.%Y}";
        tooltip = false;
      };
      network = {
        format-wifi = " {icon}";
        format-ethernet = "  ";
        format-disconnected = "󰌙";
        format-icons = [
          "󰤯 "
          "󰤟 "
          "󰤢 "
          "󰤢 "
          "󰤨 "
        ];
        tooltip = false;
      };
      battery = {
        states = {
          good = 80;
          warning = 40;
          critical = 20;
        };
        format = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        format-alt = "{time} {icon}";
        format-icons = [
          "󰂎"
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
      };
      pulseaudio = {
        max-volume = 120;
        scroll-step = 10;
        format = "{icon}";
        tooltip-format = "{volume}%";
        format-muted = " ";
        format-icons = {
          default = [
            " "
            " "
            " "
          ];
        };
        on-click = lib.getExe pkgs.pavucontrol;
      };
    };
  };
}
