final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["containers/kubernetes-mcp-server" "0.0.63"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-38hr1u1fVgiJ5AkhBhmQj/+CVfbjnHhb0k0lP9bKo4M=";
  hash-vendor = "sha256-ClcG+aGtj6Ey99ErT5OCGGusDR7aXwESLyXHWrxG8Lk=";

  version = elemAt github-tags 1;
in {
  kubernetes-mcp-server = prev.buildGoModule {
    pname = "kubernetes-mcp-server";
    inherit version;

    src = fetchFromGithubTuple {
      inherit github-tags;
      hash = hash-src;
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
