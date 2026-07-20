{
  github-tags,
  hash-src,
  extract ? (theme: theme),
}: let
  inherit (builtins) head;

  repo = head github-tags;
  matched = builtins.match "[^/]+/([^/]+)" repo;
  name =
    if matched != null
    then head matched
    else throw "Expected github-tags to start with '<owner>/<repo>', got '${repo}'";
in
  final: prev: let
    fetchFromGitHubTuple = import ./fetch_from_github_tuple.nix prev;
  in {
    "catppuccin-${name}" = prev.stdenv.mkDerivation {
      name = "catppuccin-${name}";
      src = fetchFromGitHubTuple {inherit github-tags hash-src;};
      installPhase = ''
        cp --recursive themes/${extract "mocha"} $out
      '';
    };
  }
