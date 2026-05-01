final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["openai/codex" "0.128.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash = "sha256-v2W0eslPOPHxHX76+bnkE/f4y+MnQuopeOoAC5X16TA=";
  cargoHash = "sha256-3NQ4UCfBpANhyoJJatd8m31cEugsd42Ye2BXuzlKC0c=";

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
