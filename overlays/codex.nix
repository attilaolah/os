final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.135.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash = "sha256-eHe4bjUIvSK512ZTlFcOBqv5hhM+zfzkxcLfrzDA7L4=";
  cargoHash = "sha256-DjqTn6DWfOlwdQ387eWeT5fs6qIgaD2rAXjxNStKgrs=";

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
