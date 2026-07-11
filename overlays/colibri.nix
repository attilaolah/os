final: prev: let
  inherit (builtins) elemAt;
  inherit (final.lib) splitString substring;

  github-commits = ["JustVugg/colibri" "main" "9e6e1ac327b9cc07c4934d14343d5d5251eeddfc"];
  rev = elemAt github-commits 2;

  # Auto-updated by the overlay hash refresh workflow from `github-commits`.
  revCount = 51;
  shortRev = substring 0 7 rev;
  version = "0-${toString revCount}-g${shortRev}";
  hash-src = "sha256-HK7Wq5NlYFXMPEdFbJJOPWxMLWVLlIg4Im37ZoIQsiY=";
  githubRepo = splitString "/" (elemAt github-commits 0);
in {
  colibri = final.callPackage ({
    lib,
    stdenv,
    python3,
    gnumake,
    makeWrapper,
    cudaPackages,
    symlinkJoin,
    cudaSupport ? (final.config.cudaSupport or false),
  }: let
    cudaHome = symlinkJoin {
      name = "colibri-cuda-home";
      paths = with cudaPackages; [cuda_nvcc cuda_cudart];
      postBuild = ''
        if [ -d "$out/lib" ] && [ ! -e "$out/lib64" ]; then
          ln -s lib "$out/lib64"
        fi
      '';
    };
    runtimePath = lib.makeBinPath (
      [python3]
      ++ lib.optionals stdenv.hostPlatform.isLinux [final.glibc.bin]
    );
  in
    stdenv.mkDerivation {
      pname = "colibri";
      inherit version;

      src = prev.fetchFromGitHub {
        inherit rev;
        owner = elemAt githubRepo 0;
        repo = elemAt githubRepo 1;
        hash = hash-src;
      };

      nativeBuildInputs = [gnumake makeWrapper python3] ++ lib.optionals cudaSupport [cudaHome];

      postPatch = ''
        patchShebangs c/setup.sh c/coli c/*.py c/tools
      '';

      buildPhase = ''
        runHook preBuild

        export ARCH=${
          if stdenv.hostPlatform.isx86_64
          then "x86-64-v3"
          else "native"
        }
        export CUDA=${lib.optionalString cudaSupport "1"}${lib.optionalString (!cudaSupport) "0"}
        ${lib.optionalString cudaSupport ''export CUDA_HOME=${cudaHome}''}
        ./c/setup.sh

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        install -Dm755 c/coli "$out/bin/coli"
        install -Dm755 c/glm "$out/bin/glm"
        install -Dm644 c/openai_server.py "$out/bin/openai_server.py"
        install -Dm644 c/resource_plan.py "$out/bin/resource_plan.py"
        cp -r c/tools "$out/bin/tools"
        wrapProgram "$out/bin/coli" --prefix PATH : "${runtimePath}"

        runHook postInstall
      '';

      meta = {
        description = "Tiny C engine for running GLM-5.2 with streamed experts";
        homepage = "https://github.com/JustVugg/colibri";
        license = lib.licenses.asl20;
        mainProgram = "coli";
        platforms = lib.platforms.linux ++ lib.platforms.darwin;
      };
    }) {};
}
