final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["openai/codex" "0.121.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash = "sha256-wjiUMox9V5tFggNgaFyHXWhRlpPerK7W+U/eR2Ddbbc=";
  cargoHash = "sha256-zpQ0vg9XuarLfdZYiRIhcwLHUOdunNbOb5xLW3MPzp8=";

  version = elemAt github-tags 1;
in {
  codex = prev.codex.overrideAttrs (_old: {
    inherit version cargoHash;
    src = fetchFromGithubTuple {
      inherit github-tags hash;
      rev = "rust-v${version}";
    };
  });
}
