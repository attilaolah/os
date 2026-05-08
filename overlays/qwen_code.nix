final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["QwenLM/qwen-code" "0.15.8"]; # extractVersion=^v(?<version>.*)$
  hash = "sha256-47cwb55LpXK6Sj9v5KHfjeLUsGjoGQ6zwDmnR5iVyvo=";
  npmDepsHash = "sha256-BqTTa6YSW1NnVhoJ9p2XsRTbf2/gLjAY+EzV+ThMtfg=";

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
