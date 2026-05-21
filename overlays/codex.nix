final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.133.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash = "sha256-T+iPhi0/h6+tIGZy04e8l8xjxUBH/aUQ21pXbunLYxM=";
  cargoHash = "sha256-UHgiDC/YgVgXlK+6aw8in+rOClz9D92VgKbbd+yEWHs=";

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
