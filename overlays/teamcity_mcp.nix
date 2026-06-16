final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["Daghis/teamcity-mcp" "2.12.1"]; # extractVersion=^teamcity-mcp-v(?<version>.*)$
  hash-src = "sha256-Yq0iBI6imRMsiCgjEVU4gtVqfz8yCTMeV2nvPzdOaWk=";
  hash-npm-deps = "sha256-nby3OVg4LASkUHAbQyCysvv+q6+oJc1UdspjnsMKekc=";

  version = elemAt github-tags 1;
in {
  teamcity-mcp = prev.buildNpmPackage {
    pname = "teamcity-mcp";
    inherit version;

    src = fetchFromGithubTuple {
      inherit github-tags;
      hash = hash-src;
      rev = "teamcity-mcp-v${version}";
    };

    npmDepsHash = hash-npm-deps;
    doCheck = false;

    meta = {
      description = "MCP server for TeamCity";
      homepage = "https://github.com/Daghis/teamcity-mcp";
      license = prev.lib.licenses.mit;
      mainProgram = "teamcity-mcp";
    };
  };
}
