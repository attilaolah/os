final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["marco-jardim/opencode-model-router" "1.3.0"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-nqdVWDzBD8zv/OsvAVrxA71ox8l0uacQqt4pf1PSJ1U=";
  hash-npm-deps = "sha256-cBDfogVLJlg5g5ZatXjOBcKaiqkZlZuLbFLqTyh2abE=";

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

    postPatch = ''
      cp ${./opencode_model_router/package-lock.json} package-lock.json
      ${prev.jq.bin}/bin/jq 'del(.devDependencies)' package.json > package.json.stripped
      mv package.json.stripped package.json
      ${prev.jq.bin}/bin/jq '
        .activePreset = "openai"
        | .presets.openai.fast.model = "openai/gpt-5.6-luna"
        | .presets.openai.fast.description = "GPT-5.6 Luna for fast exploration and simple tasks"
        | .presets.openai.fast.costRatio = 2
        | .presets.openai.medium.model = "openai/gpt-5.6-terra"
        | .presets.openai.medium.description = "GPT-5.6 Terra for implementation and standard coding"
        | .presets.openai.medium.costRatio = 5
        | .presets.openai.heavy.model = "openai/gpt-5.6-sol"
        | .presets.openai.heavy.description = "GPT-5.6 Sol for architecture and complex tasks"
        | .presets.openai.heavy.costRatio = 10
      ' tiers.json > tiers.json.patched
      mv tiers.json.patched tiers.json
    '';

    npmDepsHash = hash-npm-deps;
    dontNpmBuild = true;
    doCheck = false;

    passthru.plugin = "${final.opencode-model-router}/lib/node_modules/opencode-model-router/src/index.ts";

    meta = {
      description = "OpenCode plugin that routes tasks to tiered subagents based on complexity";
      homepage = "https://github.com/marco-jardim/opencode-model-router";
      license = prev.lib.licenses.gpl3Only;
    };
  };
}
