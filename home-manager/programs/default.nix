{
  desktop,
  lib,
  ...
}: let
  desktopList = list: lib.lists.optionals desktop list;
in {
  imports =
    [
      ./command-not-found.nix
      ./dircolors.nix
      ./direnv.nix
      ./fd.nix
      ./fish
      ./git.nix
      ./gpg.nix
      ./rbw.nix
      ./tealdeer.nix
      ./tmux.nix
      ./uv.nix
    ]
    ++ desktopList [
      ./hyprlock
      ./waybar
    ];
}
