{
  lib,
  platform,
  ...
}: {
  imports =
    [
      ./antigravity_cli.nix
      ./atuin.nix
      ./claude_code.nix
      ./codex.nix
      ./dircolors.nix
      ./direnv.nix
      ./fd.nix
      ./fish
      ./fzf.nix
      ./git.nix
      ./gpg.nix
      ./mcp.nix
      ./neovim
      ./nix-index.nix
      ./opencode.nix
      ./rbw.nix
      ./tealdeer.nix
      ./tmux.nix
      ./uv.nix
    ]
    ++ lib.lists.optionals (platform == "darwin") [
      ./zsh.nix
    ]
    ++ lib.lists.optionals (platform == "linux") [
      ./hyprlock
      ./waybar
    ];
}
