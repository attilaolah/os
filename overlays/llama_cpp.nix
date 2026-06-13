final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["ggml-org/llama.cpp" "9620"]; # extractVersion=^b(?<version>.*)$
  hash-src = "sha256-UhtoFuVFtqGRK+0kO6Tocuzbr556TaP+yrflTt6YUPc=";
  hash-npm-deps = "sha256-pjdbI6NcZRlJVd62xhgbLhWrwFYwgsIwjORqvo1+VD8=";

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
