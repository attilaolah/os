final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["ggml-org/llama.cpp" "8884"]; # extractVersion=^b(?<version>.*)$
  hash = "sha256-pQvoAIcoYkCI2z93YQP737Zuj3PzpgPGlR5HezRneSE=";
  npmDepsHash = "sha256-RAFtsbBGBjteCt5yXhrmHL39rIDJMCFBETgzId2eRRk=";

  version = elemAt github-tags 1;
in {
  llama-cpp = prev.llama-cpp.overrideAttrs (_old: {
    inherit version npmDepsHash;
    src = fetchFromGithubTuple {
      inherit github-tags hash;
      rev = "b${version}";
    };
  });
}
