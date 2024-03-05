{config, ...}: rec {
  input = {
    # Keyboard:
    kb_layout = config.services.xserver.xkb.layout;
    kb_variant = config.services.xserver.xkb.variant;
    kb_options = config.services.xserver.xkb.options;
    numlock_by_default = true;

    # Mouse:
    follow_mouse = 1;
    touchpad.natural_scroll = false;
    sensitivity = 0;
  };

  # RAW Hyprland config, for hyprland.greet.conf.
  hyprconf = with input; ''
    input {
      # Keyboard:
      kb_layout = ${kb_layout}
      kb_variant = ${kb_variant}
      kb_options = ${kb_options}
      numlock_by_default = ${toString numlock_by_default}

      # Mouse:
      follow_mouse = ${toString follow_mouse}
      touchpad:natural_scroll = ${
      if touchpad.natural_scroll
      then "yes"
      else "no"
    }
      sensitivity = ${toString sensitivity}
    }
  '';
}
