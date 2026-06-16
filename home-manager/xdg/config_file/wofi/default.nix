{
  fontFamily,
  fontSize,
}: let
  inherit (builtins) readFile replaceStrings;
  marker = "/* DYNAMIC STYLE */";
  replacement = ''
    * {
      font-size: ${toString fontSize}px;
      font-family: "${fontFamily}";
    }'';
in
  replaceStrings [marker] [replacement] (readFile ./style.css)
