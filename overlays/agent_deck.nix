final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["asheshgoplani/agent-deck" "1.15.0"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-LdpTOnru4r46BYwHdKknlzqnOMutH6zseQZxd/BFAOY=";
  hash-vendor = "sha256-a5wcWeauSsDmRZ9j7AG+QUOVkCRy0UnAOexPfl8mezo=";

  version = elemAt github-tags 1;
in {
  agent-deck = prev.buildGoModule {
    pname = "agent-deck";
    inherit version;

    src = fetchFromGitHubTuple {
      inherit github-tags hash-src;
      rev = "v${version}";
    };

    vendorHash = hash-vendor;
    subPackages = ["cmd/agent-deck"];
    doCheck = false;
  };
}
