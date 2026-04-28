{
  lib,
  fetchFromGitHub,
}: {
  github-tags,
  hash,
  rev ? builtins.elemAt github-tags 1,
}: let
  inherit (builtins) elemAt;
  githubRepo = lib.splitString "/" (elemAt github-tags 0);
in
  fetchFromGitHub {
    inherit hash rev;
    owner = elemAt githubRepo 0;
    repo = elemAt githubRepo 1;
  }
