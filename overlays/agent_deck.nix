final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["asheshgoplani/agent-deck" "1.16.4"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-TuqmuXDH6UxHmMd7Otu0rFtZFgHwg5yeAN4JpTagtIw=";
  hash-vendor = "sha256-jYCRbLdZxeR6gh9jyc7HTipbinj9QLoafFg8nujo9eI=";

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
