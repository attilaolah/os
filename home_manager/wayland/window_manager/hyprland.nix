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

    inherit (lib.generators) mkLuaInline;

    mon_1 = monitors."$M1";
    mon_2 = monitors."$M2";
    mon_3 = monitors."$M3";

    workspaces = [1 2 3 4 5 6 7 8];
    workspaceKeys = {
      "1" = "ampersand";
      "2" = "bracketleft";
      "3" = "braceleft";
      "4" = "braceright";
      "5" = "parenleft";
      "6" = "equal";
      "7" = "asterisk";
      "8" = "parenright";
    };

    bind = keys: dispatcher: {
      _args = [keys (mkLuaInline dispatcher)];
    };
    bindWithOptions = keys: dispatcher: options: {
      _args = [keys (mkLuaInline dispatcher) options];
    };
    exec = command: ''hl.dsp.exec_cmd(${builtins.toJSON command})'';
    focusDirection = direction: ''hl.dsp.focus({ direction = ${builtins.toJSON direction} })'';
    focusWorkspace = workspace: ''hl.dsp.focus({ workspace = ${builtins.toJSON workspace} })'';
    moveToWorkspace = workspace: ''hl.dsp.window.move({ workspace = ${builtins.toJSON workspace} })'';
  in {
    enable = true;
    configType = "lua";
    # https://wiki.hypr.land/Useful-Utilities/Systemd-start/
    systemd.enable = true;
    settings = let
      term = lib.getExe pkgs.foot;
      menu = lib.getExe (pkgs.writeShellApplication {
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
      web = lib.getExe (pkgs.writeShellApplication {
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
      print = lib.getExe (let
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
      notif = lib.getExe (pkgs.writeShellApplication {
        name = "hyprland-shortcut-notifications";
        runtimeInputs = with pkgs; [swaynotificationcenter];
        text = ''
          exec swaync-client --toggle-panel
        '';
      });
      lock = lib.getExe (pkgs.writeShellApplication {
        name = "hyprland-shortcut-lock";
        runtimeInputs = with pkgs; [systemd];
        text = ''
          exec loginctl lock-session
        '';
      });
    in {
      config = {
        inherit (input) input;

        general = {
          allow_tearing = false;
          border_size = 0;
          gaps_in = 2;
          gaps_out = 0;
          layout = "dwindle";

          col = {
            active_border = "rgba(da70d6ff)";
            inactive_border = "rgba(2b3856ff)";
          };
        };
        dwindle.preserve_split = true;

        animations.enabled = false;
        decoration = {
          blur.enabled = false;
          shadow.enabled = false;
          rounding = 0;
        };

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

        debug = {
          vfr = false;
          damage_tracking = 0;
        };
      };

      monitor = [
        {
          output = mon_1;
          mode = "2560x1440@60";
          position = "0x0";
          scale = 1;
          transform = 3;
        }
        {
          output = mon_2;
          mode = "3840x2160@60";
          position = "1440x200";
          scale = 1;
        }
        {
          output = mon_3;
          mode = "2560x1440@60";
          position = "5280x0";
          scale = 1;
          transform = 1;
        }
      ];

      workspace_rule = lib.imap1 (i: monitor: {
        inherit monitor;
        workspace = toString i;
        default = true;
      }) [mon_1 mon_2 mon_3];

      window_rule = [
        {
          match.float = true;
          border_size = 1;
        }
      ];

      bind =
        [
          (bind "SUPER + Return" (exec term))
          (bind "SUPER + Space" ''hl.dsp.window.float({ action = "toggle" })'')
          (bind "SUPER + Escape" "hl.dsp.window.close()")
          (bind "SUPER + D" "hl.dsp.window.pseudo()") #            [D]windle
          (bind "SUPER + F" "hl.dsp.window.fullscreen()") #        [F]ullscreen
          (bind "SUPER + L" (exec lock)) #                         [L]ock
          (bind "SUPER + N" (exec notif)) #                        [N]otification Centre
          (bind "SUPER + P" (exec print)) #                        [P]rint Screen
          (bind "SUPER + R" (exec menu)) #                         [R]un
          (bind "SUPER + T" ''hl.dsp.layout("togglesplit")'') #    [T]ile (Dwindle)
          (bind "SUPER + W" (exec web)) #                          [W]eb

          # Move focus with SUPER + arrow keys
          (bind "SUPER + left" (focusDirection "left"))
          (bind "SUPER + right" (focusDirection "right"))
          (bind "SUPER + up" (focusDirection "up"))
          (bind "SUPER + down" (focusDirection "down"))
          (bind "ALT + Tab" ''hl.dsp.window.cycle_next("prev")'')
          (bind "ALT + Tab" "hl.dsp.window.bring_to_top()")
          (bind "ALT + SHIFT + Tab" ''hl.dsp.window.cycle_next("next")'')
          (bind "ALT + SHIFT + Tab" "hl.dsp.window.bring_to_top()")

          # Special workspace (scratchpad)
          (bind "SUPER + S" ''hl.dsp.workspace.toggle_special("magic")'')
          (bind "SUPER + SHIFT + S" (moveToWorkspace "special:magic"))

          # Scroll through existing workspaces with SUPER + scroll
          (bind "SUPER + mouse_down" (focusWorkspace "e+1"))
          (bind "SUPER + mouse_up" (focusWorkspace "e-1"))

          # Send SIGUSR1 to toggle Waybar visibility.
          (bindWithOptions "SUPER + Super_L" (exec "systemctl --user kill -s SIGUSR1 waybar.service") {release = true;})

          # Move/resize windows with SUPER + LMB/RMB and dragging.
          (bindWithOptions "SUPER + mouse:272" "hl.dsp.window.drag()" {mouse = true;})
          (bindWithOptions "SUPER + mouse:273" "hl.dsp.window.resize()" {mouse = true;})
        ]
        # Switch workspaces with SUPER + num.
        ++ (map (n: bind "SUPER + ${workspaceKeys.${toString n}}" (focusWorkspace n)) workspaces)
        # Move active window to a workspace with SUPER + SHIFT + num.
        ++ (map (n: bind "SUPER + SHIFT + ${workspaceKeys.${toString n}}" (moveToWorkspace n)) workspaces);
    };
  };
}
