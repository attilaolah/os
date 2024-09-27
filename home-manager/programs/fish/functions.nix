{
  lib,
  pkgs,
  ...
}: let
  nix = lib.getExe pkgs.nix;
in {
  programs.fish.functions = {
    nixpkg-run = "${nix} run nixpkgs#$argv[1] -- $argv[2..]";
  };
}
