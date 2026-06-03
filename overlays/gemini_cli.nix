final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["google-gemini/gemini-cli" "0.45.0"]; # extractVersion=^v(?<version>.*)$
  hash = "sha256-FizxmHWOomlnWZoCK2lOLc94RjNTQM33vN16nLXsJI0=";
  npmDepsHash = "sha256-yn17dwHIpL3T2Z9nSOyBMehggrj4y6so7WMhnk2VwoA=";

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
