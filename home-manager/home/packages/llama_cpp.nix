{
  pkgs,
  gpu,
  ...
}: let
  version = "8884";
in ((pkgs.llama-cpp.override gpu).overrideAttrs (old: {
  inherit version;
  src = pkgs.fetchFromGitHub {
    owner = "ggml-org";
    repo = "llama.cpp";
    rev = "b${version}";
    hash = "sha256-pQvoAIcoYkCI2z93YQP737Zuj3PzpgPGlR5HezRneSE=";
  };
  npmDepsHash = "sha256-RAFtsbBGBjteCt5yXhrmHL39rIDJMCFBETgzId2eRRk=";
}))
