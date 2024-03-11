#
# ██╗  ██╗██╗   ██╗██████╗ ██████╗
# ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗
# ███████║ ╚████╔╝ ██████╔╝██████╔╝
# ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗
# ██║  ██║   ██║   ██║     ██║  ██║
# ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝
#
{
  config,
  lib,
  pkgs,
  ...
}: let
  input = import ../../../hosts/home/hyprland/input.nix {config = xkb;};
  monitors = import ../../../hosts/home/hyprland/monitors.nix {inherit lib;};
  xkb = import ../../../hosts/home/services/xserver/xkb.nix {inherit lib;};

  workspaces = [1 2 3 4 5 6 7 8];

  foot = lib.getExe pkgs.foot;
  google-chrome = lib.getExe' pkgs.google-chrome "google-chrome-stable";
  #hypridle = lib.getExe pkgs.hypridle;
  rofi = lib.getExe pkgs.rofi;
  rofi-power-menu = lib.getExe pkgs.rofi-power-menu;
  waybar = lib.getExe pkgs.waybar;
in {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      inherit (input) input;
      inherit (monitors) "$M1" "$M2" "$M3" "monitor" "workspace";

      exec-once = [
        #hypridle # TODO: ReGreet!
        monitors.exec-once
        waybar
      ];

      "$TERM" = "${foot}";
      "$MENU" = "${rofi} -show drun -theme ${config.home.homeDirectory}/.config/rofi/launchers/type-3/style-10.rasi";
      "$POWER" = "${rofi} -show menu -modi \"menu:${rofi-power-menu}\"";
      "$BROWSER" = "${google-chrome} --enable-unsafe-webgpu";

      general = {
        allow_tearing = false;
        border_size = 2;
        gaps_in = 2;
        gaps_out = 4;
        layout = "dwindle";

        "col.active_border" = "rgba(a7c080ff)";
        "col.inactive_border" = "rgba(3d484dff)";
      };

      decoration = {
        blur.enabled = false;
        drop_shadow = true;
        rounding = 2;
        shadow_range = 8;
        shadow_render_power = 3;

        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = true;

        bezier = "mybez, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 2, mybez"
          "windowsOut, 1, 2, default, popin 80%"
          "border, 1, 4, default"
          "borderangle, 1, 4, default"
          "fade, 1, 2, default"
          "workspaces, 1, 4, default"
        ];
      };

      dwindle.preserve_split = true;

      "$MOD" = "SUPER";

      # Workspaces:
      "$N1" = "ampersand";
      "$N2" = "bracketleft";
      "$N3" = "braceleft";
      "$N4" = "braceright";
      "$N5" = "parenleft";
      "$N6" = "equal";
      "$N7" = "asterisk";
      "$N8" = "parenright";

      bind =
        [
          "$MOD SHIFT, ESCAPE, exec, $POWER"
          "$MOD, Return, exec, $TERM"
          "$MOD, Space, togglefloating,"
          "$MOD, Escape, killactive,"
          "$MOD, A, exec, pavucontrol" # [a]udio
          "$MOD, B, exec, $BROWSER" #    [b]rowser
          "$MOD, D, pseudo," #           [d]windle
          "$MOD, F, fullscreen," #       [f]ullscrean
          "$MOD, R, exec, $MENU" #       [r]un
          "$MOD, T, togglesplit," #      [t]ile (dwindle)

          # Move focus with MOD + arrow keys
          "$MOD, left, movefocus, l"
          "$MOD, right, movefocus, r"
          "$MOD, up, movefocus, u"
          "$MOD, down, movefocus, d"
          "ALT, Tab, cyclenext, prev"
          "ALT, Tab, bringactivetotop"
          "ALT SHIFT, Tab, cyclenext, next"
          "ALT SHIFT, Tab, bringactivetotop"

          # Special workspace (scratchpad)
          "$MOD, S, togglespecialworkspace, magic"
          "$MOD SHIFT, S, movetoworkspace, special:magic"

          # Scroll through existing workspaces with MOD + scroll
          "$MOD, mouse_down, workspace, e+1"
          "$MOD, mouse_up, workspace, e-1"
        ]
        # Switch workspaces with MOD + num
        ++ (map (n: "$MOD, $N${toString n}, workspace, ${toString n}") workspaces)
        # Move active window to a workspace with MOD + SHIFT + num
        ++ (map (n: "$MOD SHIFT, $N${toString n}, movetoworkspace, ${toString n}") workspaces);

      bindm = [
        # Move/resize windows with MOD + LMB/RMB and dragging
        "$MOD, mouse:272, movewindow"
        "$MOD, mouse:273, resizewindow"
      ];

      misc = {
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
      };
    };
  };
}
