final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["google-gemini/gemini-cli" "0.40.0"]; # extractVersion=^v(?<version>.*)$
  hash = "sha256-O0TBrT3WDCBZ3ZyFyJPBBtPfnDzdFQ7b8pOJOD7bj2g=";
  npmDepsHash = "sha256-y0LafX1+ukW8HRYBqQ3QfZGHo1cVk00bNygdwsBR/7g=";

  version = elemAt github-tags 1;
in {
  gemini-cli = prev.gemini-cli.overrideAttrs (old: let
    src = fetchFromGithubTuple {
      inherit github-tags hash;
      rev = "v${version}";
    };
  in {
    inherit version npmDepsHash src;
    npmDeps = old.npmDeps.overrideAttrs (_: {
      inherit src;
      outputHash = npmDepsHash;
    });
  });
}
