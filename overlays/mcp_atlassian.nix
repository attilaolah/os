final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;
  py = prev.python3Packages;

  github-tags = ["sooperset/mcp-atlassian" "0.23.0"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-aTiPYMhZwWCjS/S9pZgdb4oFbXyNO7Q/aMUt0bKfSjM=";

  version = elemAt github-tags 1;
in {
  mcp-atlassian = py.buildPythonApplication {
    pname = "mcp-atlassian";
    inherit version;
    pyproject = true;

    src = fetchFromGitHubTuple {
      inherit github-tags hash-src;
      rev = "v${version}";
    };

    build-system = with py; [
      hatchling
      uv-dynamic-versioning
    ];

    dependencies = with py; [
      atlassian-python-api
      beautifulsoup4
      cachetools
      click
      fakeredis
      fastmcp
      httpx
      keyring
      markdown
      prev.markdown-to-confluence
      markdownify
      mcp
      pydantic
      python-dateutil
      python-dotenv
      requests
      starlette
      thefuzz
      trio
      truststore
      unidecode
      urllib3
      uvicorn
    ];

    pythonRelaxDeps = [
      "fakeredis"
      "markdown-to-confluence"
    ];
    pythonRemoveDeps = [
      "types-cachetools"
      "types-python-dateutil"
      "tzdata"
    ];

    doCheck = false;

    meta = {
      description = "MCP server for Atlassian products";
      homepage = "https://github.com/sooperset/mcp-atlassian";
      license = prev.lib.licenses.mit;
      mainProgram = "mcp-atlassian";
    };
  };
}
