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

  simple_modifications = builtins.attrValues (
    builtins.mapAttrs (from: to: {
      from.key_code = from;
      to = [{key_code = to;}];
    }) {
      caps_lock = "escape";
      non_us_backslash = "grave_accent_and_tilde";
    }
  );

  complex_modifications.rules = let
    any = key_code: mandatory: from key_code mandatory ["any"];
    from = key_code: mandatory: optional: {
      from = {
        inherit key_code;
        modifiers =
          (
            if mandatory == []
            then {}
            else {inherit mandatory;}
          )
          // {inherit optional;};
      };
    };
    to = key_code: modifiers: {to = [{inherit key_code modifiers;}];};
    basic = manipulators: map (mod: mod // {type = "basic";}) manipulators;
  in [
    {
      description = "Windows/Linux-style text navigation shortcuts";
      manipulators = basic [
        ((any "left_arrow" ["control" "shift"]) // (to "left_arrow" ["option" "shift"]))
        ((any "right_arrow" ["control" "shift"]) // (to "right_arrow" ["option" "shift"]))
        ((any "left_arrow" ["control"]) // (to "left_arrow" ["option"]))
        ((any "right_arrow" ["control"]) // (to "right_arrow" ["option"]))
      ];
    }
  ];
}
