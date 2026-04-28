final: prev: let
  version = "8884";
  hash = "sha256-pQvoAIcoYkCI2z93YQP737Zuj3PzpgPGlR5HezRneSE=";
  npmDepsHash = "sha256-RAFtsbBGBjteCt5yXhrmHL39rIDJMCFBETgzId2eRRk=";
in {
  llama-cpp = prev.llama-cpp.overrideAttrs (_old: {
    inherit version npmDepsHash;
    src = prev.fetchFromGitHub {
      inherit hash;
      owner = "ggml-org";
      repo = "llama.cpp";
      rev = "b${version}";
    };
  });
}
