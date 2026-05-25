final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.133.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash = "sha256-RTxhhZjZ/64N60pmbNVzLwcSBomn67pPDpOjkL6RPUw=";
  cargoHash = "sha256-J4wvPn4lSTSsJrTG56vkhJe2F2b+fUvJLEd+qKQ9LUg=";

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
