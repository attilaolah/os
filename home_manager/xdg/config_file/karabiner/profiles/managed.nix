let
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
    dvp = {
      f = "y";
      h = "j";
      j = "c";
      l = "p";
      n = "l";
      p = "r";
      s = "semicolon";
      t = "k";
      u = "f";
      w = "comma";
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
    frontmost = bundle_identifier: manipulators:
      map (mod:
        mod
        // {
          conditions = [
            {
              type = "frontmost_application_if";
              bundle_identifiers = ["^${builtins.replaceStrings ["."] ["\\."] bundle_identifier}$"];
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
      manipulators = basic (frontmost "com.google.Chrome" (
        (map
          # Remap Ctrl+Shift+Key to Cmd+Option+Key:
          (key: ((any dvp.${key} ["control" "shift"]) // (to dvp.${key} ["command" "option"])))
          [
            "j" # developer tools
          ])
        ++ (map
          # Remap Ctrl+Shift+Key to Cmd+Shift+Key:
          (key: ((any dvp.${key} ["control" "shift"]) // (to dvp.${key} ["command" "shift"])))
          [
            "t" # most recent tab
            "n" # new incognito window
          ])
        ++ (map
          # Remap Ctrl+Key to Cmd+Option+Key:
          (key: ((any dvp.${key} ["control"]) // (to dvp.${key} ["command" "option"])))
          [
            "u" # view page source
          ])
        ++ (map
          # Remap Ctrl+Key to Cmd+Shift+Key:
          (key: ((any dvp.${key} ["control"]) // (to dvp.${key} ["command" "shift"])))
          [
            "j" # downloads
          ])
        ++ (map
          # Remap Ctrl+Key to Cmd+Key:
          (key: ((any dvp.${key} ["control"]) // (to dvp.${key} ["command"])))
          [
            "f" # find
            "l" # jump to the address bar
            "n" # new window
            "p" # print
            "s" # save page as
            "t" # new tab
            "w" # close tab
          ])
        ++ [
          ((any dvp.h ["control"]) // (to dvp.y ["command"]))
        ]
      ));
    }
  ];
}
