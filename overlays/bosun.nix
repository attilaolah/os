final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["yetidevworks/bosun" "2.1.8"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-gZSbmFIzPUMObtKTDf8cK2Xrgwrbbr+nBq6L5CdnUUY=";
  hash-cargo-deps = "sha256-WgjrkzFD7tJcGJEYIDy6aKGmuzPNse1D5LjPL1E0m/4=";

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
