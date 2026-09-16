final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["DeusData/codebase-memory-mcp" "0.11.0"];
  hash-src = "sha256-6CrxqkyxfsSENQBAuS7hwZFgQX+4Ocxx0CH6eIeqw3E=";
  hash-npm-deps = "sha256-W3cajM1XXy19EgGSJyXsd00KncAm7v4afnnnHXIqlhc=";

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
