final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;
  py = prev.python3Packages;

  github-tags = ["sooperset/mcp-atlassian" "0.23.0"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-KSkKiseEaDjF0ROPqLf/kO9yA7n8GV9eK96b0VMbDg4=";

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

    patches = [
      (prev.fetchpatch {
        url = "https://github.com/sooperset/mcp-atlassian/commit/b089ed8b3b7ccdde207ce3ab2b7ef88e412a6f53.patch";
        hash = "sha256-Jyyb6iKJT84Ee8DtNswwsH3wsNSokXHtkwrjz30eQuo=";
      })
      (prev.fetchpatch {
        url = "https://github.com/sooperset/mcp-atlassian/commit/4822b754c93d562ada627fa84a985703e3ba9e46.patch";
        hash = "sha256-wlIeVinKPAdFGJxYF15pi145ZrTeJ7oCkzUifLjxyyo=";
        excludes = ["uv.lock"];
      })
      (prev.fetchpatch {
        url = "https://github.com/attilaolah/mcp-atlassian/commit/e41849b9b5294d61e67546fe9005caaeebae078b.patch";
        hash = "sha256-FZeigTPnb8sdloClCoP0DPFJxlwA1J1qa5ofs72EtsM=";
        excludes = ["uv.lock"];
      })
    ];

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
