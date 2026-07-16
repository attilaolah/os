final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["marco-jardim/opencode-model-router" "1.3.0"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-nqdVWDzBD8zv/OsvAVrxA71ox8l0uacQqt4pf1PSJ1U=";
  hash-npm-deps = "sha256-b2hq/uhb7FBiA4X1rkq5mPs8XMtGtjq5q5tasZ4kh14=";

  version = elemAt github-tags 1;
in {
  opencode-model-router = prev.buildNpmPackage {
    pname = "opencode-model-router";
    inherit version;

    src = fetchFromGithubTuple {
      inherit github-tags;
      hash = hash-src;
      rev = "v${version}";
    };

    npmDepsHash = hash-npm-deps;
    dontNpmBuild = true;

    postPatch = ''
      cp ${./opencode_model_router/package.json} package.json
      cp ${./opencode_model_router/package-lock.json} package-lock.json
    '';

    installPhase = ''
      runHook preInstall

      packageRoot=$out/lib/node_modules/opencode-model-router
      mkdir -p "$packageRoot"
      cp -R . "$packageRoot"

      runHook postInstall
    '';

    passthru.pluginPath = "${final.opencode-model-router}/lib/node_modules/opencode-model-router/src/index.ts";

    meta = {
      description = "OpenCode plugin for automatic model-tier delegation";
      homepage = "https://github.com/marco-jardim/opencode-model-router";
      license = prev.lib.licenses.gpl3Only;
    };
  };
}
