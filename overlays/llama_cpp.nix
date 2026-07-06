final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["ggml-org/llama.cpp" "9884"]; # extractVersion=^b(?<version>.*)$
  hash-src = "sha256-3LUQa70lIt6b6mQfqus4v9EMR9dw/2ik6AaTvq0HB/4=";
  hash-npm-deps = "sha256-TU4Gv+dd48WDpswhfVtm79IVIOwoCXz1fZ/DI/z40Wg=";

  version = elemAt github-tags 1;
in {
  llama-cpp = prev.llama-cpp.overrideAttrs (_: {
    inherit version;
    npmDepsHash = hash-npm-deps;
    src = fetchFromGithubTuple {
      inherit github-tags;
      hash = hash-src;
      rev = "b${version}";
    };
  });
}
