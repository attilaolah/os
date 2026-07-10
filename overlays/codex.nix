final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.144.1"]; # extractVersion=^rust-v(?<version>.*)$
  hash-src = "sha256-KHgrqIZyAmLhTZSRYbb7huBO8neOib/B1Vx/oPW2nEU=";
  hash-cargo-deps = "sha256-S4dsZXfmKvJItL2XYKyxfhqdCMATEG6oPjrtVRwkuYc=";

  version = elemAt github-tags 1;
in {
  codex = prev.codex.overrideAttrs (_: let
    src = fetchFromGithubTuple {
      inherit github-tags;
      hash = hash-src;
      rev = "rust-v${version}";
    };
  in {
    inherit version src;
    cargoHash = hash-cargo-deps;
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      cargoRoot = "codex-rs";
      hash = hash-cargo-deps;
    };
  });
}
