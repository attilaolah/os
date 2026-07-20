final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["asheshgoplani/agent-deck" "1.10.10"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-7JDWo/FKZdlr88ZCetWOWnPRgNzLbB4f1hOPIddA6Pg=";
  hash-vendor = "sha256-XOhLr599GEMwJNdGD4/C28zZNmTD4hGTsFN2mGvUDXA=";

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
