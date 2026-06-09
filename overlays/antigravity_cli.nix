final: prev: let
  inherit (builtins) elemAt getAttr;

  github-tags = ["google-antigravity/antigravity-cli" "1.0.3"];
  version = elemAt github-tags 1;
  build = "6459114696605696";

  hash-src-aarch64-darwin = "sha256-lbf6dCJ7QhDNomfpi10Dhk9VShxAxTC0zsFIFpGlbtA=";
  hash-src-aarch64-linux = "sha256-Cp44KTj1wP85y6Z6oCOd1ylL2nTg1mDx7aJuv/Q7nBE=";
  hash-src-x86_64-darwin = "sha256-B1zPkt4h3JN7ZWhin0iTQMCe+NhVvBGKWCLfKnBrZnw=";
  hash-src-x86_64-linux = "sha256-UM/b3TuXROHHx0dKMU0KtENNREmY+VAYKmxRWewu/ic=";

  source-url = system: let
    parts = prev.lib.splitString "-" system;
    cpu = elemAt parts 0;
    os = elemAt parts 1;
  in "https://storage.googleapis.com/antigravity-public/antigravity-cli/${version}-${build}/${os}-${
    getAttr cpu {
      x86_64 = "x64";
      aarch64 = "arm";
    }
  }/cli_${getAttr os {
    linux = "linux";
    darwin = "mac";
  }}_${getAttr cpu {
    x86_64 = "x64";
    aarch64 = "arm64";
  }}.tar.gz";
in {
  antigravity-cli = prev.antigravity-cli.overrideAttrs (old: let
    sources = prev.lib.mapAttrs (_: source: prev.fetchzip source) {
      x86_64-linux = {
        url = source-url "x86_64-linux";
        hash = hash-src-x86_64-linux;
      };
      aarch64-linux = {
        url = source-url "aarch64-linux";
        hash = hash-src-aarch64-linux;
      };
      aarch64-darwin = {
        url = source-url "aarch64-darwin";
        hash = hash-src-aarch64-darwin;
      };
      x86_64-darwin = {
        url = source-url "x86_64-darwin";
        hash = hash-src-x86_64-darwin;
      };
    };
  in {
    inherit version;
    src =
      sources.${prev.stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${prev.stdenv.hostPlatform.system}");
    passthru = old.passthru // {inherit sources;};
  });
}
