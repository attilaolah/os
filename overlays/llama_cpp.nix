final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["ggml-org/llama.cpp" "9590"]; # extractVersion=^b(?<version>.*)$
  hash-src = "sha256-rWOhgQUOtpF6KhHuGnY9iFj6YiSjiscGGdwMFji8gwo=";
  hash-npm-deps = "sha256-Iyg8FpcTKf2UYHuK7mA3cTAqVaLcQPcS0YCa5Qf01Gc=";

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
