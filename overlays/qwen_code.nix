final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["QwenLM/qwen-code" "0.15.11"]; # extractVersion=^v(?<version>.*)$
  hash = "sha256-ZhP7dkF8Y5WjAzq8V8gP0RFGFzGlqlGnIQAaFstcT3A=";
  npmDepsHash = "sha256-/zr16GQ0msKGTwnPbTp0wk20EPzzOf9A92/iKkdtnEE=";

  version = elemAt github-tags 1;
in {
  qwen-code = prev.qwen-code.overrideAttrs (old: let
    src = fetchFromGithubTuple {
      inherit github-tags hash;
      rev = "v${version}";
    };
  in {
    inherit version npmDepsHash src;
    npmDeps = old.npmDeps.overrideAttrs (_: {
      inherit src;
      outputHash = npmDepsHash;
    });
  });
}
