final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;
  py = prev.python3Packages;

  github-tags = ["hunyadi/md2conf" "0.6.1"];
  hash-src = "sha256-DFGFDJYpadcRZ6gJ4yjYHS7d+oJtu4L/fwKIyJDNneA=";

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
      cattrs
      lxml
      markdown
      orjson
      pymdown-extensions
      pyyaml
      requests
      truststore
    ];

    pythonRelaxDeps = [
      "cattrs" # https://github.com/NixOS/nixpkgs/pull/534685
      "lxml"
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
