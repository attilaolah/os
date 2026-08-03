final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["containers/kubernetes-mcp-server" "0.0.66"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-vnJxSCfnpvOZJXQpKrCAW4QKt5R2PJDYQevA7O1uXZg=";
  hash-vendor = "sha256-gbqoT4X+wVOEktHm7jaAH9vHrUBrYgR8OjyFz1ljP6k=";

  version = elemAt github-tags 1;
in {
  kubernetes-mcp-server = prev.buildGoModule {
    pname = "kubernetes-mcp-server";
    inherit version;

    src = fetchFromGitHubTuple {
      inherit github-tags hash-src;
      rev = "v${version}";
    };

    vendorHash = hash-vendor;
    subPackages = ["cmd/kubernetes-mcp-server"];

    doCheck = false;

    meta = {
      description = "MCP server for Kubernetes";
      homepage = "https://github.com/containers/kubernetes-mcp-server";
      license = prev.lib.licenses.asl20;
      mainProgram = "kubernetes-mcp-server";
    };
  };
}
