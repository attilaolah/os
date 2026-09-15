_final: prev: let
  breakFilesystemSearchImportCycle = prev.fetchpatch {
    url = "https://github.com/anomalyco/opencode/commit/7f392ba6178ac1be6f2b6385293a61586cd98a87.patch";
    hash = "sha256-cUYvOpsOsdDMuMjrh9FC3O+sM+r5RHTRSjH95Az7/mE=";
  };
  useNixpkgsBunVersion = ''
    substituteInPlace package.json \
      --replace-fail \
        '"packageManager": "bun@1.3.14"' \
        '"packageManager": "bun@${prev.bun.version}"'
  '';
  omitEmptyMcpArguments = ''
    substituteInPlace packages/opencode/src/mcp/catalog.ts \
      --replace-fail \
        'arguments: (args || {}) as Record<string, unknown>,' \
        'arguments: Object.fromEntries(Object.entries((args || {}) as Record<string, unknown>).filter(([, value]) => value !== "")),'
  '';
  patchPreBuild = attrs: {preBuild = (attrs.preBuild or "") + useNixpkgsBunVersion;};
  patchPostPatch = attrs: {postPatch = (attrs.postPatch or "") + omitEmptyMcpArguments;};
  patchPatches = attrs: {patches = (attrs.patches or []) ++ [breakFilesystemSearchImportCycle];};
in {
  opencode = prev.opencode.overrideAttrs (oldAttrs:
    {
      node_modules = oldAttrs.node_modules.overrideAttrs (nodeModulesAttrs: let
        brokenHash =
          if prev.stdenv.hostPlatform.isLinux
          then "sha256-tHl+UGkUbalkh+C5RDkRpZ3Q87tgvqnoF4xdih6QeOw="
          else if prev.stdenv.hostPlatform.isDarwin
          then "sha256-28GpwYLMo2cN4Y9cY6/xn9R5EggFj/m1guuSxsbqisM="
          else nodeModulesAttrs.outputHash;
        outputHash =
          if prev.stdenv.hostPlatform.isLinux
          then "sha256-F1ygMH30D/a/T8SaUuY69+LjBGnkHNLmQTvvrsz6NQA="
          else if prev.stdenv.hostPlatform.isDarwin
          then "sha256-EWS/DKClw1KPZ4iXR+q48QGkSojWy1kgdstUAPh7NaE="
          else nodeModulesAttrs.outputHash;
      in
        assert nodeModulesAttrs.outputHash == brokenHash;
          (patchPreBuild nodeModulesAttrs) // {inherit outputHash;});
    }
    // patchPreBuild oldAttrs
    // patchPostPatch oldAttrs
    // patchPatches oldAttrs);
}
