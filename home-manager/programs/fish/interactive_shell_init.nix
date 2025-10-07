{
  lib,
  pkgs,
  ...
}: {
  programs.fish.interactiveShellInit = ''
    set --universal fish_greeting
    set --global --export GPG_AGENT_INFO (
      ${lib.getExe' pkgs.gnupg "gpgconf"} --list-dirs agent-socket
    )

    ${lib.getExe pkgs.direnv} hook fish | source
    ${lib.getExe pkgs.fzf} --fish | source
    ${lib.getExe pkgs.zoxide} init --cmd cd fish | source
    ${lib.getExe pkgs.any-nix-shell} fish | source
  '';
}
