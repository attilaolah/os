final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["google-gemini/gemini-cli" "0.41.2"]; # extractVersion=^v(?<version>.*)$
  hash = "sha256-4jwEviWYzan97pVn0RWfWU4XS8c27L4ZJUwa2iGlFxY=";
  npmDepsHash = "sha256-4znN1YR3AX2SKeCJjUS8cm6WGcOGPXI27xrQCotBjgQ=";

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
