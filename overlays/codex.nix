final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.140.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash-src = "sha256-XjzlkBUkBey+P3tFLDYB3ae5oseUfW5tmzhLzqlqj2E=";
  hash-cargo-deps = "sha256-8mN4OTRJvt2mBYHQXZS55PSOChLqEIiXwPu2y+2MZ9o=";

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
