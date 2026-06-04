final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["google-gemini/gemini-cli" "0.45.1"]; # extractVersion=^v(?<version>.*)$
  hash = "sha256-XZGqZMylKQi7Cc74qvvz50UY4EIJ19bjOYOwD39L2yo=";
  npmDepsHash = "sha256-uD6635fzjGwiD0dUY0aCUonsO0zLFw00eidb87bXNh4=";

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
