{
  fontFamily,
  fontSize,
}: let
  inherit (builtins) readFile replaceStrings;
  marker = "# DYNAMIC STYLE";
  replacement = ''
    font-family = "${fontFamily}"
    font-size = ${toString fontSize}'';
in
  replaceStrings [marker] [replacement] (readFile ./config)
