{
  lib,
  pkgs,
  ...
}: let
  catppuccin-fzf-mocha = pkgs.stdenv.mkDerivation {
    name = "catppuccin-fzf-mocha";
    # TODO: renovate
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "fzf";
      rev = "7c2e05606f2e75840b1ba367b1f997cd919809b3";
      sha256 = "sha256-fs3bOs1vfrtuono0yg1xjTSpzoS5m8ZRMD+CjAp+sDU=";
    };
    installPhase = ''
      cp --recursive themes/catppuccin-fzf-mocha.fish $out
    '';
  };
in {
  programs.fish.interactiveShellInit = ''
    set --universal fish_greeting
    set --global --export GPG_AGENT_INFO (
      ${lib.getExe' pkgs.gnupg "gpgconf"} --list-dirs agent-socket
    )

    source ${catppuccin-fzf-mocha}
    set --universal --export FZF_DEFAULT_OPTS "--style=full $FZF_DEFAULT_OPTS"

    ${lib.getExe pkgs.direnv} hook fish | source
    ${lib.getExe pkgs.fzf} --fish | source
    ${lib.getExe pkgs.zoxide} init --cmd cd fish | source
    ${lib.getExe pkgs.any-nix-shell} fish | source
  '';
}
