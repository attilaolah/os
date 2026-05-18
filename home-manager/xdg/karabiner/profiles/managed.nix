{
  name = "Managed";
  selected = true;
  virtual_hid_keyboard.keyboard_type_v2 = "iso";

  devices = let
    # Keyboard identifiers.
    # Any keyboard (in practice, this applies to the built-in keyboard).
    keyboard.is_keyboard = true;
    # Das Keyboard:
    das_keyboard = {
      product_id = 320;
      vendor_id = 9456;
    };
    # Keyboard-specific remapping.
    remap = key_code: {
      simple_modifications = [
        {
          from = {inherit key_code;};
          # Remap the key right of the space bar as the built-in compose key.
          to = [{key_code = "non_us_backslash";}];
        }
      ];
    };
  in [
    ({identifiers = keyboard;} // (remap "right_command"))
    ({identifiers = keyboard // das_keyboard;} // (remap "right_option"))
  ];

  simple_modifications = [
    {
      from.key_code = "caps_lock";
      to = [{key_code = "escape";}];
    }
    {
      from.key_code = "non_us_backslash";
      to = [{key_code = "grave_accent_and_tilde";}];
    }
  ];

  complex_modifications.rules = [
    {
      description = "Windows/Linux-style text navigation shortcuts";
      manipulators = [
        {
          from = {
            key_code = "left_arrow";
            modifiers = {
              mandatory = [
                "control"
                "shift"
              ];
              optional = ["any"];
            };
          };
          to = [
            {
              key_code = "left_arrow";
              modifiers = [
                "option"
                "shift"
              ];
            }
          ];
          type = "basic";
        }
        {
          from = {
            key_code = "right_arrow";
            modifiers = {
              mandatory = [
                "control"
                "shift"
              ];
              optional = ["any"];
            };
          };
          to = [
            {
              key_code = "right_arrow";
              modifiers = [
                "option"
                "shift"
              ];
            }
          ];
          type = "basic";
        }
        {
          from = {
            key_code = "left_arrow";
            modifiers = {
              mandatory = ["control"];
              optional = ["any"];
            };
          };
          to = [
            {
              key_code = "left_arrow";
              modifiers = ["option"];
            }
          ];
          type = "basic";
        }
        {
          from = {
            key_code = "right_arrow";
            modifiers = {
              mandatory = ["control"];
              optional = ["any"];
            };
          };
          to = [
            {
              key_code = "right_arrow";
              modifiers = ["option"];
            }
          ];
          type = "basic";
        }
        {
          from = {
            key_code = "home";
            modifiers = {
              mandatory = ["shift"];
              optional = ["any"];
            };
          };
          to = [
            {
              key_code = "left_arrow";
              modifiers = [
                "command"
                "shift"
              ];
            }
          ];
          type = "basic";
        }
        {
          from = {
            key_code = "end";
            modifiers = {
              mandatory = ["shift"];
              optional = ["any"];
            };
          };
          to = [
            {
              key_code = "right_arrow";
              modifiers = [
                "command"
                "shift"
              ];
            }
          ];
          type = "basic";
        }
        {
          from = {
            key_code = "home";
            modifiers.optional = ["any"];
          };
          to = [
            {
              key_code = "left_arrow";
              modifiers = ["command"];
            }
          ];
          type = "basic";
        }
        {
          from = {
            key_code = "end";
            modifiers.optional = ["any"];
          };
          to = [
            {
              key_code = "right_arrow";
              modifiers = ["command"];
            }
          ];
          type = "basic";
        }
      ];
    }
  ];
}
