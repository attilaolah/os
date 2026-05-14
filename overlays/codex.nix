final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.130.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash = "sha256-YeUeYbzUMUx0lhIKdtPa8vUYK2Cj1hmbLb68Y80r71o=";
  cargoHash = "sha256-cpkj7H/jkKGbfJ92Ty9peqfxibFw2aWWG64tmgeG+2o=";

  version = elemAt github-tags 1;
in {
  codex = prev.codex.overrideAttrs (_: let
    src = fetchFromGithubTuple {
      inherit github-tags hash;
      rev = "rust-v${version}";
    };
  in {
    inherit version cargoHash src;
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      cargoRoot = "codex-rs";
      hash = cargoHash;
    };
  });
}
