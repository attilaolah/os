{
  desktop,
  lib,
  ...
}: let
  desktopList = list: lib.lists.optionals desktop list;
in {
  imports =
    [
      ./gpg_agent.nix
    ]
    ++ desktopList [
      ./hypridle.nix
      ./hyprpaper
      ./swaync.nix
    ];
}
