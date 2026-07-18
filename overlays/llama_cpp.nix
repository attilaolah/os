final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["ggml-org/llama.cpp" "10066"]; # extractVersion=^b(?<version>.*)$
  hash-src = "sha256-R5oiaZcuDsw64xLhUHosO89Nlz8J/IqMX1bHEMHebuk=";
  hash-npm-deps = "sha256-6s9skw1wzEfm9QKktTqea3J+oudQAsS6O2VnZEMXAdw=";

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
