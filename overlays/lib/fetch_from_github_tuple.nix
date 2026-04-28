{
  lib,
  fetchFromGitHub,
}: {
  github-tags,
  hash,
  rev ? null,
}: let
  inherit (builtins) elemAt isList isString length throw;
  githubRepo = lib.splitString "/" (elemAt github-tags 0);
  resolvedRev =
    if rev == null
    then elemAt github-tags 1
    else rev;
in
  assert (isList github-tags && length github-tags >= 2)
  || throw "github-tags must be a list of at least two strings: owner and repo";
  assert (
    isString (elemAt github-tags 0)
    && elemAt github-tags 0 != ""
    && isString (elemAt github-tags 1)
    && elemAt github-tags 1 != ""
  )
  || throw "github-tags must contain non-empty string values for the first two elements";
    fetchFromGitHub {
      inherit hash;
      rev = resolvedRev;
      owner = elemAt githubRepo 0;
      repo = elemAt githubRepo 1;
    }
