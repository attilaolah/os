final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["asheshgoplani/agent-deck" "1.16.11"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-kRnVaNF8M6uPl+iPpx6OooR3JOOk76D7EDWegHU8jeM=";
  hash-vendor = "sha256-ZIBWsEa6IpoW66/kd40UNihBrbo5yjCsRIQatCbt4q8=";

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
