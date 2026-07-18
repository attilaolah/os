final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["asheshgoplani/agent-deck" "1.10.10"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-4LbeRiaFIn4Nx/VtDvhJAaeA7YB6i2VX8wZhJ75qw5k=";
  hash-vendor = "sha256-teB9HxMGOe5YGW0RGxVOhkDPyczCDdjATRV9Mn9ixDU=";

  version = elemAt github-tags 1;
in {
  agent-deck = prev.buildGoModule {
    pname = "agent-deck";
    inherit version;

    src = fetchFromGithubTuple {
      inherit github-tags;
      hash = hash-src;
      rev = "v${version}";
    };

    vendorHash = hash-vendor;
    subPackages = ["cmd/agent-deck"];
    doCheck = false;
  };
}
