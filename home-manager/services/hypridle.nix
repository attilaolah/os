# https://mynixos.com/home-manager/options/services.hypridle
{
  lib,
  pkgs,
  ...
}: {
  services.hypridle = {
    enable = true;
    settings = let
      prefix = "hyipridle";
      lockSession = lib.getExe (pkgs.writeShellApplication {
        name = "${prefix}-lock-session";
        runtimeInputs = with pkgs; [systemd];
        text = ''
          exec loginctl lock-session
        '';
      });
      dpmsOff = lib.getExe (pkgs.writeShellApplication {
        name = "${prefix}-dpms-off";
        runtimeInputs = with pkgs; [hyprland];
        text = ''
          exec hyprctl dispatch dpms off
        '';
      });
      dpmsOn = lib.getExe (pkgs.writeShellApplication {
        name = "${prefix}-dpms-on";
        runtimeInputs = with pkgs; [hyprland];
        text = ''
          exec hyprctl dispatch dpms on
        '';
      });
    in {
      general = {
        lock_cmd = lib.getExe pkgs.hyprlock;
        before_sleep_cmd = lockSession;
        after_sleep_cmd = dpmsOff;
      };

      listener = [
        {
          timeout = 20 * 60;
          on-timeout = dpmsOff;
          on-resume = dpmsOn;
        }
        {
          timeout = 12 * 60;
          on-timeout = lockSession;
        }
      ];
    };
  };
}
