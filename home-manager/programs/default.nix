{
  desktop,
  lib,
  ...
}: let
  desktopList = list: lib.lists.optionals desktop list;
in {
  imports =
    [
      ./atuin.nix
      ./dircolors.nix
      ./direnv.nix
      ./fd.nix
      ./fish
      ./fzf.nix
      ./git.nix
      ./gpg.nix
      ./nix-index.nix
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
