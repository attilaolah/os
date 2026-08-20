final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;
  py = prev.python3Packages;
  github-tags = ["headroomlabs-ai/headroom" "0.36.0"]; # extractVersion=^v(?<version>.*)$
  hash-src = "sha256-0sMu0EDCY+pd38nBBXTNDUUfE8Nx6lvUP46I403yMz8=";
  hash-cargo-deps = "sha256-c2WJVyt+4rb6Sc49whrni3maQh/Ql29bFeVViNl41oM=";

  pname = "headroom-ai";
  version = elemAt github-tags 1;
  src = fetchFromGitHubTuple {
    inherit github-tags hash-src;
    rev = "v${version}";
  };
in {
  python3Packages = py.overrideScope (_pyFinal: pyPrev: {
    headroom-ai = pyPrev.buildPythonPackage {
      inherit pname version src;
      pyproject = true;

      cargoDeps = final.rustPlatform.fetchCargoVendor {
        inherit pname version src;
        hash = hash-cargo-deps;
      };
      build-system = [
        final.cargo
        final.rustPlatform.cargoSetupHook
        final.rustPlatform.maturinBuildHook
        final.rustc
      ];

      # The upstream [all] extra covers every supported runtime feature.
      dependencies = with pyPrev; [
        ast-grep-cli
        click
        datasets
        fastapi
        fastembed
        httpx
        jinja2
        magika
        mcp
        numpy
        onnxruntime
        openai
        openpyxl
        opentelemetry-api
        opentelemetry-exporter-otlp-proto-http
        opentelemetry-sdk
        orjson
        pillow
        pydantic
        pyyaml
        rapidocr
        rich
        scikit-learn
        sentence-transformers
        sentencepiece
        sqlite-vec
        tiktoken
        tomlkit
        torch
        trafilatura
        transformers
        tree-sitter
        tree-sitter-language-pack
        uvicorn
        watchdog
        websockets
        xlrd
        zstandard
      ];

      doCheck = false;

      meta = {
        description = "Context optimization layer for LLM applications";
        homepage = "https://github.com/headroomlabs-ai/headroom";
        license = final.lib.licenses.asl20;
        mainProgram = "headroom";
      };
    };
  });

  headroom-ai = final.python3Packages.headroom-ai;
}
