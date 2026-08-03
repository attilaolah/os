final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["asheshgoplani/agent-deck" "1.11.0"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-OyFvkRmE3sXfQ4R8pfUWUC/0zAlZUv2aJDo3H0QNbas=";
  hash-vendor = "sha256-Pq4EGQGn21oKWNsEAkULrsygqJ2ZjamZGRCLe706ZqY=";

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
