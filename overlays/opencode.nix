_final: prev: let
  breakFilesystemSearchImportCycle = prev.fetchpatch {
    url = "https://github.com/anomalyco/opencode/commit/7f392ba6178ac1be6f2b6385293a61586cd98a87.patch";
    hash = "sha256-AnG+asHaWzDp9HpeviX5QrAWzGq5/vGjp3djm6en8Eo=";
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
      node_modules = oldAttrs.node_modules.overrideAttrs (nodeModulesAttrs:
        assert nodeModulesAttrs.outputHash == "sha256-28GpwYLMo2cN4Y9cY6/xn9R5EggFj/m1guuSxsbqisM=";
          (patchPreBuild nodeModulesAttrs) // {outputHash = "sha256-EWS/DKClw1KPZ4iXR+q48QGkSojWy1kgdstUAPh7NaE=";});
    }
    // patchPreBuild oldAttrs
    // patchPostPatch oldAttrs
    // patchPatches oldAttrs);
}
