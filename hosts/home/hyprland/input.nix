{config, ...}: {
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
}
