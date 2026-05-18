{
  profiles = [
    {
      complex_modifications = {
        rules = [
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
      };
      devices = [
        {
          identifiers.is_keyboard = true;
          simple_modifications = [
            {
              from.key_code = "right_command";
              to = [{key_code = "non_us_backslash";}];
            }
          ];
        }
        {
          identifiers = {
            is_keyboard = true;
            product_id = 320;
            vendor_id = 9456;
          };
          simple_modifications = [
            {
              from.key_code = "right_option";
              to = [{key_code = "non_us_backslash";}];
            }
          ];
        }
      ];
      name = "Developer";
      selected = true;
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
      virtual_hid_keyboard.keyboard_type_v2 = "iso";
    }
  ];
}
