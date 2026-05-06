final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["google-gemini/gemini-cli" "0.41.2"]; # extractVersion=^v(?<version>.*)$
  hash = "sha256-8T13ROsE6NVR120NbFThADjSYy1PApAXqdHzclSA2yc=";
  npmDepsHash = "sha256-YHo3mAG9UlEg8J5SCzCu2YhKdlz7lFPon5SweKWQ8rk=";

  version = elemAt github-tags 1;
in {
  gemini-cli = prev.gemini-cli.overrideAttrs (old: let
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
