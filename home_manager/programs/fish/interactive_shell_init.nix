{
  lib,
  pkgs,
  ...
}: {
  programs.fish.interactiveShellInit = ''
    set fish_greeting
    # TODO: Remove this line once the atuin home-manager module is fixed for fish > 4.3.0
    set -g fish_key_bindings fish_default_key_bindings

    set --global --export GPG_AGENT_INFO (
      ${lib.getExe' pkgs.gnupg "gpgconf"} --list-dirs agent-socket
    )

    # Re-bind fzf's default find-file from Ctrl+T to Ctrl+F.
    # This frees up Ctrl+T, passing it through to be used as the new-tab shortcut in bosun.
    bind --erase --mode insert --user \ct
    bind --erase --mode insert --preset \ct
    bind \cf fzf-file-widget

    source ${pkgs.catppuccin-fzf}
    set --export FZF_DEFAULT_OPTS "--style=full $FZF_DEFAULT_OPTS"
    set --export ATUIN_THEME_DIR "${pkgs.catppuccin-atuin}"

    ${lib.getExe pkgs.direnv} hook fish | source
    ${lib.getExe pkgs.zoxide} init --cmd cd fish | source
    ${lib.getExe pkgs.any-nix-shell} fish | source
  '';
}
