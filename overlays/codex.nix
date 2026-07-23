final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.145.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash-src = "sha256-/r4mBoJhHB1v5NTA4Hk565/D5B0deYJf9xJW330hyf0=";
  hash-cargo-deps = "sha256-t9IMRK9R+Z67ThEcgBI0HQU0E4aJHcOjKp22RFclh9U=";

  version = elemAt github-tags 1;
in {
  codex = prev.codex.overrideAttrs (oldAttrs: let
    src = fetchFromGitHubTuple {
      inherit github-tags hash-src;
      rev = "rust-v${version}";
    };
    obsoleteWebrtcPatch = ''
      substituteInPlace $cargoDepsCopy/*/webrtc-sys-*/build.rs \
        --replace-fail "cargo:rustc-link-lib=static=webrtc" "cargo:rustc-link-lib=dylib=webrtc"
    '';
  in
    assert prev.lib.assertMsg
    (prev.lib.hasInfix obsoleteWebrtcPatch oldAttrs.postPatch)
    "The obsolete Codex WebRTC postPatch override can be removed.";
    {
    inherit version src;
    cargoHash = hash-cargo-deps;
    postPatch = prev.lib.replaceStrings [obsoleteWebrtcPatch] [""] oldAttrs.postPatch;
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      cargoRoot = "codex-rs";
      hash = hash-cargo-deps;
    };
  });
}
