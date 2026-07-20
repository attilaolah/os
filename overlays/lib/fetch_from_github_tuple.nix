{
  lib,
  fetchFromGitHub,
  ...
}: {
  github-tags,
  hash-src,
  rev ? null,
}: let
  inherit (builtins) elemAt isList isString length throw;
  githubRepo = lib.splitString "/" (elemAt github-tags 0);
  resolvedRev =
    if rev == null
    then elemAt github-tags 1
    else rev;
in
  assert (isList github-tags && length github-tags == 2)
  || throw ''github-tags must be a 2-item list: ["owner/repo" "version-or-rev"]'';
  assert (
    isString (elemAt github-tags 0)
    && elemAt github-tags 0 != ""
    && length (lib.splitString "/" (elemAt github-tags 0)) == 2
    && elemAt (lib.splitString "/" (elemAt github-tags 0)) 0 != ""
    && elemAt (lib.splitString "/" (elemAt github-tags 0)) 1 != ""
    && isString (elemAt github-tags 1)
    && elemAt github-tags 1 != ""
  )
  || throw "github-tags must contain a non-empty owner/repo slug and version";
    fetchFromGitHub {
      hash = hash-src;
      rev = resolvedRev;
      owner = elemAt githubRepo 0;
      repo = elemAt githubRepo 1;
    }
