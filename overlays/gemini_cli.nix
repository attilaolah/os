final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["google-gemini/gemini-cli" "0.40.1"]; # extractVersion=^v(?<version>.*)$
  hash = "sha256-oWznf9xleb9bpW2dnMIUehkMqKCb6AecZjcVwZgBrdo=";
  npmDepsHash = "sha256-sscqcey+hPsfajrTspy6FScjfFmtvJMP1w56cFuu3DI=";

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
