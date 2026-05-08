final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["openai/codex" "0.129.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash = "sha256-IvBeuDiP1vMzCGVxi4CWKcYajP+IkNIyHmREO5gz2dU=";
  cargoHash = "sha256-H4iqXfcT9mvU6O4j5TybfyKEpx522iaggS68AC1jbU8=";

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
