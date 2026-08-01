# https://mynixos.com/home-manager/options/services.hypridle
{
  lib,
  pkgs,
  ...
}: {
  services.hypridle = {
    enable = true;
    settings = let
      dpms = action:
        lib.getExe (pkgs.writeShellApplication {
          name = "hypridle-dpms-${action}";
          runtimeInputs = with pkgs; [hyprland];
          text = ''
            exec hyprctl dispatch 'hl.dsp.dpms({ action = "${action}" })'
          '';
        });
      disable = dpms "disable";
      lock = lib.getExe (pkgs.writeShellApplication {
        name = "hypridle-lock-session";
        runtimeInputs = with pkgs; [systemd];
        text = ''
          exec loginctl lock-session
        '';
      });
    in {
      general = {
        lock_cmd = lib.getExe pkgs.hyprlock;
        before_sleep_cmd = lock;
        after_sleep_cmd = disable;
      };

      listener = [
        {
          timeout = 20 * 60;
          on-timeout = disable;
          on-resume = dpms "enable";
        }
        {
          timeout = 12 * 60;
          on-timeout = lock;
        }
      ];
    };
  };
}
