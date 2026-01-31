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
}: {
  wayland.windowManager.hyprland = let
    input = import ../../../hosts/home/hyprland/input.nix {
      config = import ../../../hosts/home/services/xserver.nix {inherit lib;};
    };
    monitors = import ../../../hosts/home/hyprland/monitors.nix;

    workspaces = [1 2 3 4 5 6 7 8];
  in {
    enable = true;
    # https://wiki.hypr.land/Useful-Utilities/Systemd-start/
    systemd.enable = false;
    settings = {
      inherit (input) input;
      inherit (monitors) "$M1" "$M2" "$M3" "monitor" "workspace";

      exec-once = [
        monitors.exec-once
        (lib.getExe' pkgs.swaynotificationcenter "swaync")
      ];

      "$TERM" = lib.getExe pkgs.foot;
      "$MENU" = lib.getExe (pkgs.writeShellApplication {
        name = "hyprland-shortcut-menu";
        runtimeInputs = with pkgs; [wofi];
        text = ''
          wofi \
            --show drun \
            --allow-images \
            --allow-markup \
            --hide-scroll \
            --no-actions \
            --columns 4 \
            --lines 12
        '';
      });
      "$WEB" = lib.getExe (pkgs.writeShellApplication {
        name = "hyprland-shortcut-web";
        runtimeInputs = with pkgs; [google-chrome];
        # Force dark mode until the underlying issues are resolved.
        # Disable Wayland colour management, to work around Hyprland issue, see here:
        # https://github.com/hyprwm/Hyprland/discussions/11961#discussioncomment-14620023
        text = ''
          exec google-chrome-stable \
            --ozone-platform=wayland \
            --disable-features=WaylandWpColorManagerV1 \
            --force-dark-mode
        '';
      });
      "$PRINT" = lib.getExe (let
        screenshots = "${config.home.homeDirectory}/photos/screen";
      in
        pkgs.writeShellApplication {
          name = "hyprland-shortcut-print";
          runtimeInputs = with pkgs; [coreutils grim slurp wl-clipboard];
          text = ''
            mkdir --parents "${screenshots}"
            grim -g "$(slurp)" - |
              tee "${screenshots}/$(date --iso-8601=seconds | tr : -).png" |
              wl-copy -t image/png
          '';
        });
      "$NOTIF" = lib.getExe (pkgs.writeShellApplication {
        name = "hyprland-shortcut-notifications";
        runtimeInputs = with pkgs; [swaynotificationcenter];
        text = ''
          exec swaync-client --toggle-panel
        '';
      });
      "$LOCK" = lib.getExe (pkgs.writeShellApplication {
        name = "hyprland-shortcut-lock";
        runtimeInputs = with pkgs; [hyprlock];
        text = ''
          exec hyprlock --immediate
        '';
      });

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
        shadow.enabled = false;
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
          "$MOD, D, pseudo," #           [D]windle
          "$MOD, F, fullscreen," #       [F]ullscrean
          "$MOD, L, exec, $LOCK" #       [L]ock
          "$MOD, N, exec, $NOTIF" #      [N]otification Centre
          "$MOD, P, exec, $PRINT" #      [P]rint Screen
          "$MOD, R, exec, $MENU" #       [R]un
          "$MOD, T, togglesplit," #      [T]ile (Dwindle)
          "$MOD, W, exec, $WEB" #        [W]eb

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

        # RawTherapee renders keep causing this to pop up.
        anr_missed_pings = 8; # default = 1
      };

      # NVIDIA experimental hardware cursor support.
      # Currently very much broken on rotated monitors.
      # cursor = {
      #   no_hardware_cursors = 0;
      #   use_cpu_buffer = true;
      # };

      opengl.nvidia_anti_flicker = true;

      misc.vfr = 0;

      debug.damage_tracking = 0;
    };
  };
}
