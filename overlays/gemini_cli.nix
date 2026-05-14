final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["google-gemini/gemini-cli" "0.42.0"]; # extractVersion=^v(?<version>.*)$
  hash = "sha256-QYSzJdyjJ5SvPkI/uf/wu8MdM76W+djai6zD38IJpos=";
  npmDepsHash = "sha256-hKNEJ/MAseYs8WLr36h40pYv+5nef8EPhZIfmPKYJPY=";

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
