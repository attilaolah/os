{
  pkgs,
  lib,
  config,
  ...
}: let
  #brightnessctl = lib.getExe pkgs.brightnessctl;
  #loginctl = lib.getExe' pkgs.systemd "loginctl";
  #hyprlock = lib.getExe config.programs.hyprlock.package;
  #hyprctl = lib.getExe' config.programs.hyprland.package "hyprctl";
  #hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
in {
  services.hypridle = {
    enable = true;

    #lockCmd = hyprlock;
    #beforeSleepCmd = "${loginctl} lock-session";
    #afterSleepCmd = "${hyprctl} dispatch dpms on";

    #listeners = [
    #  {
    #    timeout = 60 * 2;
    #    onTimeout = "${brightnessctl} --save set 5%";
    #    onResume = "${brightnessctl} --restore";
    #  }
    #  {
    #    timeout = 60 * 10;
    #    onTimeout = "${hyprctl} dispatch dpms off";
    #    onResume = "${hyprctl} dispatch dpms on";
    #  }
    #];
  };
}
