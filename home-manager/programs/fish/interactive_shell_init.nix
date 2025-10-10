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
  catppuccin-atuin-mocha = pkgs.stdenv.mkDerivation {
    name = "catppuccin-atuin-mocha";
    # TODO: renovate
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "atuin";
      rev = "abfab12de743aa73cf20ac3fa61e450c4d96380c";
      sha256 = "sha256-t/Pq+hlCcdSigtk5uzw3n7p5ey0oH/D5S8GO/0wlpKA=";
    };
    installPhase = ''
      cp --recursive themes/mocha $out
    '';
  };
in {
  programs.fish.interactiveShellInit = ''
    set fish_greeting
    set --global --export GPG_AGENT_INFO (
      ${lib.getExe' pkgs.gnupg "gpgconf"} --list-dirs agent-socket
    )

    source ${catppuccin-fzf-mocha}
    set --export FZF_DEFAULT_OPTS "--style=full $FZF_DEFAULT_OPTS"
    set --export ATUIN_THEME_DIR "${catppuccin-atuin-mocha}"

    ${lib.getExe pkgs.direnv} hook fish | source
    ${lib.getExe pkgs.zoxide} init --cmd cd fish | source
    ${lib.getExe pkgs.any-nix-shell} fish | source
  '';
}
