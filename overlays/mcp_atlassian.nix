final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;
  py = prev.python3Packages;

  github-tags = ["sooperset/mcp-atlassian" "0.21.1"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-KSkKiseEaDjF0ROPqLf/kO9yA7n8GV9eK96b0VMbDg4=";
  markdownToConfluenceHash = "sha256-4fnu6z/sQGKVbml/E426wA1HN7Y7qqZptA79bbxlMFw=";

  version = elemAt github-tags 1;
  markdown-to-confluence = py.buildPythonPackage rec {
    pname = "markdown_to_confluence";
    version = "0.3.4";
    pyproject = true;

    src = py.fetchPypi {
      inherit pname version;
      hash = markdownToConfluenceHash;
    };

    build-system = [py.setuptools];
    dependencies = with py; [
      lxml
      markdown
      pymdown-extensions
      pyyaml
      requests
    ];

    pythonRemoveDeps = [
      "types-lxml"
      "types-markdown"
      "types-PyYAML"
      "types-requests"
    ];

    doCheck = false;
  };
in {
  mcp-atlassian = py.buildPythonApplication {
    pname = "mcp-atlassian";
    inherit version;
    pyproject = true;

    src = fetchFromGithubTuple {
      inherit github-tags;
      hash = hash-src;
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
      markdown-to-confluence
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
      "fastmcp"
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
