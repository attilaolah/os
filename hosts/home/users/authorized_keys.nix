{
  pkgs,
  user,
  ...
}: let
  inherit (pkgs) lib;
in {
  users.users."${user.username}".openssh.authorizedKeys.keys = lib.splitString "\n" (lib.removeSuffix "\n" (builtins.readFile (pkgs.fetchurl {
    url = "https://github.com/attilaolah.keys";
    hash = "sha256-Nw/XiCnJ+KmHK1YFO3x9MF+GPfCWWyPmy//go4UKg/M=";
  })));
}
