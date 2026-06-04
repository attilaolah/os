final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.137.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash = "sha256-MI9VrfMFuUOup0e8KECaFA8SbkrPLEG+6K/wqLA8rs8=";
  cargoHash = "sha256-zHNOUHUnyNxYSWn13H77ZdIuv09kHSlJfQBatTugLUA=";

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
