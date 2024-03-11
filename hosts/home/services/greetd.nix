{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  #hyprctl = lib.getExe' config.programs.hyprland.package hyprctl;
  #hyprland = lib.getExe config.programs.hyprland.package;
  #regreet = lib.getExe config.programs.regreet.package;
  # 1st Hyperland only runs "command" (regreet) and exits.
  # ReGreet itself will then run a second session with the user's config.
  #hyprland-greet = "${hyprland} --config ${pkgs.writeText "hyprland.greet.conf" ''
  #  ${(builtins.readFile ../hyprland/greet.conf)}
  #  ${(import ../hyprland/input.nix {inherit config;}).hyprconf}
  #  ${(import ../hyprland/monitors.nix {inherit lib;}).hyprconf}
  #  exec-once = ${regreet} -l debug; ${hyprctl} dispatch exit
  #''}";
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        #command = hyprland-greet;
        user = "greeter";
      };
    };
  };
}
