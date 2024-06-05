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
  hyprlock,
  lib,
  pkgs,
  system,
  ...
}: let
  input = import ../../../hosts/home/hyprland/input.nix {config = xkb;};
  monitors = import ../../../hosts/home/hyprland/monitors.nix;
  xkb = import ../../../hosts/home/services/xserver/xkb.nix {inherit lib;};

  workspaces = [1 2 3 4 5 6 7 8];

  date = lib.getExe' pkgs.coreutils "date";
  foot = lib.getExe pkgs.foot;
  google-chrome = lib.getExe' pkgs.google-chrome "google-chrome-stable";
  grim = lib.getExe pkgs.grim;
  hidle = lib.getExe pkgs.hypridle;
  hlock = lib.getExe hyprlock.packages.${system}.default;
  mkdir = lib.getExe' pkgs.coreutils "mkdir";
  slurp = lib.getExe pkgs.slurp;
  swaync = lib.getExe' pkgs.swaynotificationcenter "swaync";
  swaync-client = lib.getExe' pkgs.swaynotificationcenter "swaync-client";
  tr = lib.getExe' pkgs.coreutils "tr";
  waybar = lib.getExe pkgs.waybar;
  wofi = lib.getExe pkgs.wofi;

  screenshots = "${config.home.homeDirectory}/photos/screen";
in {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      inherit (input) input;
      inherit (monitors) "$M1" "$M2" "$M3" "monitor" "workspace";

      exec-once = [
        hidle
        monitors.exec-once
        swaync
        waybar
        "${mkdir} --parents \"${screenshots}\""
      ];

      "$TERM" = "${foot}";
      "$MENU" =
        "${wofi}"
        + " --show drun"
        + " --allow-images"
        + " --allow-markup"
        + " --hide-scroll"
        + " --no-actions"
        + " --columns 4"
        + " --lines 12";
      "$BROWSER" =
        "${google-chrome}"
        # TODO: Enable these flags once they become more stable?
        #+ " --enable-features=SkiaGraphite,Vulkan"
        #+ " --enable-skia-graphite"
        #+ " --enable-unsafe-webgpu"
        + " --ozone-platform=wayland";
      "$PRINT" =
        "${grim}"
        + " -g \"$(${slurp})\""
        + " \"${screenshots}/$(${date} --iso-8601=seconds | ${tr} : -).png\"";
      "$NOTIF" =
        "${swaync-client}"
        + " --toggle-panel";
      "$LOCK" = hlock;

      general = {
        allow_tearing = false;
        border_size = 8;
        gaps_in = 0;
        gaps_out = 0;
        layout = "dwindle";

        "col.active_border" = "rgba(181825ff)";
        "col.inactive_border" = "rgba(11111bff)";
      };
      dwindle.preserve_split = true;

      animations.enabled = false;
      decoration = {
        blur.enabled = false;
        drop_shadow = false;
        rounding = 0;
      };

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
          "$MOD, Return, exec, $TERM"
          "$MOD, Space, togglefloating,"
          "$MOD, Escape, killactive,"
          "$MOD, A, exec, pavucontrol" # [a]udio
          "$MOD, B, exec, $BROWSER" #    [b]rowser
          "$MOD, D, pseudo," #           [d]windle
          "$MOD, F, fullscreen," #       [f]ullscrean
          "$MOD, L, exec, $LOCK" #       [l]ock
          "$MOD, N, exec, $NOTIF" #      [n]otification centre
          "$MOD, P, exec, $PRINT" #      [p]rint screen
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
