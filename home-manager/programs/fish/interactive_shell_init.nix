{
  lib,
  pkgs,
  ...
}: let
  any-nix-shell = lib.getExe pkgs.any-nix-shell;
  direnv = lib.getExe pkgs.direnv;
  gpgconf = lib.getExe' pkgs.gnupg "gpgconf";
  zoxide = lib.getExe pkgs.zoxide;
in {
  programs.fish.interactiveShellInit = ''
    set --universal fish_greeting
    set --global --export GPG_AGENT_INFO (${gpgconf} --list-dirs agent-socket)

    source ${pkgs.fzf}/share/fish/vendor_functions.d/fzf_key_bindings.fish
    source ${pkgs.fzf}/share/fish/vendor_conf.d/load-fzf-key-bindings.fish

    ${any-nix-shell} fish | source
    ${direnv} hook fish | source
    ${zoxide} init --cmd cd fish | source
  '';
}
