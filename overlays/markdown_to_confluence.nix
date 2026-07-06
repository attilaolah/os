final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;
  py = prev.python3Packages;

  github-tags = ["hunyadi/md2conf" "0.6.1"];
  hash-src = "sha256-iUkLbsu/KTzPwBX9+bSwdXsxV6NDe7iTHF+fKHZH7R0=";

  version = elemAt github-tags 1;
in {
  markdown-to-confluence = py.buildPythonPackage {
    pname = "markdown_to_confluence";
    inherit version;
    pyproject = true;

    src = fetchFromGithubTuple {
      inherit github-tags;
      hash = hash-src;
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

    meta = {
      description = "Publish Markdown files to Confluence wiki";
      homepage = "https://github.com/hunyadi/md2conf";
      license = prev.lib.licenses.mit;
    };
  };
}
