final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["yetidevworks/bosun" "2.1.1"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-JU1DnFIHJ4QcYSIilYnK3Pv1tyR2bKxe4MGWvbuF1wM=";
  hash-cargo-deps = "sha256-XlTOth2oCbg2IQBs7etKMRH1fTsX7QBQjE9I7y9r8ns=";

  version = elemAt github-tags 1;
in {
  bosun = prev.rustPlatform.buildRustPackage {
    pname = "bosun";
    inherit version;

    src = fetchFromGitHubTuple {
      inherit github-tags hash-src;
      rev = "v${version}";
    };

    cargoHash = hash-cargo-deps;
    nativeCheckInputs = [prev.git];

    meta = {
      description = "Tmux-native orchestrator for AI agent sessions";
      homepage = "https://github.com/yetidevworks/bosun";
      license = prev.lib.licenses.mit;
      mainProgram = "bosun";
    };
  };
}
