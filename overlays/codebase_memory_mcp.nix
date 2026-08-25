final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["DeusData/codebase-memory-mcp" "0.10.8"];
  hash-src = "sha256-lPuayLN6W31zQ45UTQehP+tmoo/UrQJuRsJzi1wZ9Tg=";
  hash-npm-deps = "sha256-cDwGJi8M/t7eTHVKu6TzW7L9OUAQgB+0c+fiTgPn7cE=";

  version = elemAt github-tags 1;
  src = fetchFromGitHubTuple {
    inherit github-tags hash-src;
    rev = "v${version}";
  };
in {
  codebase-memory-mcp = prev.codebase-memory-mcp.overrideAttrs (old: {
    inherit src version;
    patches =
      prev.lib.filter (patch: builtins.baseNameOf patch != "remove-install-update.diff")
      (old.patches or [])
      ++ [./codebase_memory_mcp/remove-install-update.diff];
    postPatch = ''
      substituteInPlace Makefile.cbm --replace-fail "npm ci &&" ""
      patchShebangs scripts/embed-frontend.sh
    '';
    npmDeps = prev.fetchNpmDeps {
      src = "${src}/graph-ui";
      hash = hash-npm-deps;
    };
  });
}
