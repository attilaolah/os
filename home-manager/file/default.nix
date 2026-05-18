{
  lib,
  pkgs,
  ...
}: {
  home.file = let
    toINI = lib.generators.toINI {};
  in
    {
      ".sops.yaml".text = lib.generators.toYAML {} {
        creation_rules = [
          {pgp = "BF2E475974D388E0E30C960407E6C0643FD142C3";}
        ];
      };
      ".ssh/config".text = ''
        # Force GPG-agent's pinentry to use the current tmux pane.
        Match host * exec "gpg-connect-agent UPDATESTARTUPTTY /bye"
      '';
      ".subversion/config".text = toINI {
        auth = {
          store-passwords = "yes";
          store-auth-creds = "yes";
          password-stores = "gpg-agent";
        };
      };
      ".subversion/servers".text = toINI {
        global.store-passwords = "yes";
      };
    }
    // lib.attrsets.optionalAttrs pkgs.stdenv.isDarwin {
      "Library/KeyBindings/DefaultKeyBinding.dict".text = builtins.readFile ./default_key_binding.dict;
      "Library/Keyboard Layouts/Programmer Dvorak Compose.bundle/Contents/Info.plist".source = ./library/keyboard_layout/programmer_dvorak_compose.bundle/contents/info.plist;
      "Library/Keyboard Layouts/Programmer Dvorak Compose.bundle/Contents/version.plist".source = ./library/keyboard_layout/programmer_dvorak_compose.bundle/contents/version.plist;
      "Library/Keyboard Layouts/Programmer Dvorak Compose.bundle/Contents/Resources/English.lproj/InfoPlist.strings".source = ./library/keyboard_layout/programmer_dvorak_compose.bundle/contents/resources/english.lproj/info_plist.strings;
      "Library/Keyboard Layouts/Programmer Dvorak Compose.bundle/Contents/Resources/Programmer Dvorak Compose.keylayout".source = ./library/keyboard_layout/programmer_dvorak_compose.bundle/contents/resources/programmer_dvorak_compose.keylayout;
    };
}
