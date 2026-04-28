final: prev: let
  inherit (builtins) elemAt;

  github-tags = ["ggml-org/llama.cpp" "8884"]; # extractVersion=^b(?<version>.*)$
  hash = "sha256-pQvoAIcoYkCI2z93YQP737Zuj3PzpgPGlR5HezRneSE=";
  npmDepsHash = "sha256-RAFtsbBGBjteCt5yXhrmHL39rIDJMCFBETgzId2eRRk=";

  version = elemAt github-tags 1;
  githubRepo = prev.lib.splitString (elemAt github-tags 0) "/";
in {
  llama-cpp = prev.llama-cpp.overrideAttrs (_old: {
    inherit version npmDepsHash;
    src = prev.fetchFromGitHub {
      inherit hash;
      owner = elemAt githubRepo 0;
      repo = elemAt githubRepo 1;
      rev = "b${version}";
    };
  });
}
