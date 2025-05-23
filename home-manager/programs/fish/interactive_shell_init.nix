{
  lib,
  pkgs,
  ...
}: let
  any-nix-shell = lib.getExe pkgs.any-nix-shell;
  direnv = lib.getExe pkgs.direnv;
  zoxide = lib.getExe pkgs.zoxide;
in {
  programs.fish.interactiveShellInit = ''
    set --universal fish_greeting

    source ${pkgs.fzf}/share/fish/vendor_functions.d/fzf_key_bindings.fish
    source ${pkgs.fzf}/share/fish/vendor_conf.d/load-fzf-key-bindings.fish

    ${any-nix-shell} fish | source
    ${direnv} hook fish | source
    ${zoxide} init --cmd cd fish | source
  '';
}
