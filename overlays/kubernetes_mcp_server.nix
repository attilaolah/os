final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["containers/kubernetes-mcp-server" "v0.0.62"];
  hash-src = "sha256-m4oM8KMcDmXwIGaFw+VdnW22kLjt2SaD7qZV4kgTiu8=";
  hash-vendor = "sha256-JNeYn/IfzQ2VLDbHgrkserh3wrXYOWXBczBn2DUO6NM=";

  version = elemAt github-tags 1;
in {
  kubernetes-mcp-server = prev.buildGoModule {
    pname = "kubernetes-mcp-server";
    inherit version;

    src = fetchFromGithubTuple {
      inherit github-tags;
      hash = hash-src;
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
