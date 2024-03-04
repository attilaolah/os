{ inputs, pkgs, ... }:

let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  hyprland-session = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/share/wayland-sessions";
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
      options = "caps:escape,compose:ralt,keypad:atm,kpdl:semi,numpad:shift3";
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${tuigreet} --time --remember --remember-session --sessions ${hyprland-session}";
          user = "greeter";
        };
      };
    };
  };
}
