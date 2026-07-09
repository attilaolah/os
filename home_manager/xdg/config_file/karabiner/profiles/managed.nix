let
  inherit (builtins) attrValues mapAttrs;

  # Keyboard identifiers.
  # Any keyboard (in practice, this applies to the built-in keyboard).
  keyboard.is_keyboard = true;
  # Das Keyboard:
  das_keyboard = {
    product_id = 320;
    vendor_id = 9456;
  };
in {
  name = "Managed";
  selected = true;
  virtual_hid_keyboard.keyboard_type_v2 = "iso";

  devices = let
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

  simple_modifications = attrValues (
    mapAttrs (from: to: {
      from.key_code = from;
      to = [{key_code = to;}];
    }) {
      caps_lock = "escape";
      non_us_backslash = "grave_accent_and_tilde";
    }
  );

  complex_modifications.rules = let
    inherit (builtins) attrNames concatMap elemAt head isAttrs replaceStrings;

    dvp = {
      a = "a";
      c = "i";
      f = "y";
      h = "j";
      j = "c";
      l = "p";
      n = "l";
      p = "r";
      s = "semicolon";
      t = "k";
      u = "f";
      v = "period";
      w = "comma";
      x = "b";
      y = "t";
    };
    das_keyboard_only.conditions = [
      {
        type = "device_if";
        identifiers = [das_keyboard];
      }
    ];

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
    shortcuts = concatMap (
      spec: let
        from_modifiers = elemAt spec 0;
        to_modifiers = elemAt spec 1;
        keys = elemAt spec 2;
      in
        map (
          key: let
            mapping =
              if isAttrs key
              then key
              else {${key} = key;};
            from_key = head (attrNames mapping);
            to_key = mapping.${from_key};
          in
            (any dvp.${from_key} from_modifiers) // (to dvp.${to_key} to_modifiers)
        )
        keys
    );
    frontmost = bundle_identifier: manipulators:
      map (mod:
        mod
        // {
          conditions = [
            {
              type = "frontmost_application_if";
              bundle_identifiers = ["^${replaceStrings ["."] ["\\."] bundle_identifier}$"];
            }
          ];
        })
      manipulators;
  in [
    {
      description = "App and window switching shortcuts";
      manipulators = basic [
        ((any "tab" ["option" "shift"]) // (to "tab" ["command" "shift"]))
        ((any "tab" ["option"]) // (to "tab" ["command"]))
        ((any "grave_accent_and_tilde" ["command" "shift"]) // (to "equal_sign" ["command" "option" "shift"]))
        ((any "grave_accent_and_tilde" ["command"]) // (to "equal_sign" ["command" "option"]))
        ((any "grave_accent_and_tilde" ["left_option"]) // (to "equal_sign" ["command" "option"]) // das_keyboard_only)
      ];
    }
    {
      description = "Text navigation shortcuts";
      manipulators = basic [
        ((any "left_arrow" ["control" "shift"]) // (to "left_arrow" ["option" "shift"]))
        ((any "right_arrow" ["control" "shift"]) // (to "right_arrow" ["option" "shift"]))
        ((any "left_arrow" ["control"]) // (to "left_arrow" ["option"]))
        ((any "right_arrow" ["control"]) // (to "right_arrow" ["option"]))
      ];
    }
    {
      description = "Chrome shortcuts";
      manipulators = basic (frontmost "com.google.Chrome" (shortcuts [
        [["control" "shift"] ["command" "shift"] ["t" "n"]]
        [["control" "shift"] ["command" "option"] ["j"]]
        [["control"] ["command" "shift"] ["j"]]
        [["control"] ["command" "option"] ["u"]]
        [["control"] ["command"] ["a" "c" "f" "l" "n" "p" "s" "t" "v" "w" "x" {h = "y";}]]
      ]));
    }
  ];
}
