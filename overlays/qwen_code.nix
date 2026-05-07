final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["QwenLM/qwen-code" "0.15.7"]; # extractVersion=^v(?<version>.*)$
  hash = "sha256-AMp4a1pInYppJmrUP1eg7Vhcca+amA1CK5izdvYrXOE=";
  npmDepsHash = "sha256-n7QcJjoW2r77qCW6A3qLmsWEJSHKGv+SalNBRzTcz+E=";

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
