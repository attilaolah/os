{ config, inputs, lib, pkgs, ... }:

let
  regreet = lib.getExe config.programs.regreet.package;
  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
  hyprland-keyboard = ''
  input {
    kb_layout = ${config.services.xserver.xkb.layout}
    kb_variant = ${config.services.xserver.xkb.variant}
    kb_options = ${config.services.xserver.xkb.options}
  }
  '';

  # 1st Hyperland only runs "command" (regreet) and exits.
  # ReGreet itself will then run a second session with the user's config.
  hyprland-greet = "${hyprland}/bin/Hyprland --config ${pkgs.writeText "hyprland.greet.conf" ''
    ${(builtins.readFile ./hyprland/greet.conf)}
    ${(builtins.readFile ./hyprland/input.conf)}
    ${(builtins.readFile ./hyprland/monitors.conf)}
    ${hyprland-keyboard}
    exec-once = ${regreet} -l debug; ${hyprland}/bin/hyprctl dispatch exit
  ''}";

in {
  services = {
    blueman.enable = true;
    dbus.enable = true;

    openssh = {
      enable = true;
      startWhenNeeded = true;  # make it socket-activated
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    # Only used on the virtual console.
    xserver.xkb = {
      layout = "us";
      variant = "dvp";
      options = (lib.concatStringsSep "," [
        "caps:escape"
        "compose:ralt"
        "keypad:atm"
        "kpdl:semi"
        "numpad:shift3"
      ]);
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = hyprland-greet;
          user = "greeter";
        };
      };
    };
  };
}
