final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["yetidevworks/bosun" "2.1.12"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-df55wX9PgiDUhia0adOJKe2a04wk5V2PX2xg57iWCMw=";
  hash-cargo-deps = "sha256-KBxRYvDUM1pPAFaXoY/rpM3QX6OCDJeCOOGfmipse4U=";

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
