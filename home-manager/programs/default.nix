{
  lib,
  platform,
  ...
}: {
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
      ./neovim
      ./nix-index.nix
      ./rbw.nix
      ./tealdeer.nix
      ./tmux.nix
      ./uv.nix
    ]
    ++ lib.lists.optionals (platform == "linux") [
      ./hyprlock
      ./waybar
    ];
}
