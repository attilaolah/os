final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["ggml-org/llama.cpp" "9624"]; # extractVersion=^b(?<version>.*)$
  hash-src = "sha256-50K5Qv/iQvyqczAhhgJVeFYYlz1P6iHLrq6AKjSG7UM=";
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
