final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["asheshgoplani/agent-deck" "1.13.0"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-KRpsc6NYMhQtkAQxxGjqMEcN4tTuXJq31YiqLltvDLI=";
  hash-vendor = "sha256-8BPwKIAIkrw6fLxIRgLW9Nn36vTOzDKjBeD2PeZUCLg=";

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
