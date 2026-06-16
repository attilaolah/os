final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["MatanYemini/bitbucket-mcp" "5.0.6"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-eBykQN/R38ajAvVFC+lgGC5/WdbKfC5hjmBRgxcz6OM=";
  hash-npm-deps = "sha256-rrjV7AV7MiDmVP4BfPKJ8I4bLEkdBFLSgyL67nUO89Q=";

  version = elemAt github-tags 1;
in {
  bitbucket-mcp = prev.buildNpmPackage {
    pname = "bitbucket-mcp";
    inherit version;

    src = fetchFromGithubTuple {
      inherit github-tags;
      hash = hash-src;
      rev = "v${version}";
    };

    npmDepsHash = hash-npm-deps;
    doCheck = false;

    meta = {
      description = "MCP server for Bitbucket";
      homepage = "https://github.com/MatanYemini/bitbucket-mcp";
      license = prev.lib.licenses.mit;
      mainProgram = "bitbucket-mcp";
    };
  };
}
