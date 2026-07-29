final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.146.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash-src = "sha256-/kTIOX/klxm1nq2bJsBqS8f1jZZp2ilaTeULQFPJgDk=";
  hash-cargo-deps = "sha256-N9jbH/cgAyu2QxneSnpkdaF0MgV3ZtDmN9q6rr9u+hE=";

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
