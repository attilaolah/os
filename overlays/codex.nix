final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.154.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash-src = "sha256-Nm+61N6YHxGhjLsm/giVSEg4QvJmIgWxyTQ1L89kpCs=";
  hash-cargo-deps = "sha256-9F8dyEiVkhelrIyfQ9ZkvuxfIYNN6akbpadREa4A1n0=";

  version = elemAt github-tags 1;
in {
  codex = prev.codex.overrideAttrs (_: let
    src = fetchFromGitHubTuple {
      inherit github-tags hash-src;
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
