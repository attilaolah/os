{
  github-tags,
  hash,
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
    fetchFromGithubTuple = import ./fetch_from_github_tuple.nix prev;
  in {
    "catppuccin-${name}" = prev.stdenv.mkDerivation {
      name = "catppuccin-${name}";
      src = fetchFromGithubTuple {inherit github-tags hash;};
      installPhase = ''
        cp --recursive themes/${extract "mocha"} $out
      '';
    };
  }
