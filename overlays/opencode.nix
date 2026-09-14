_final: prev: let
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
in {
  opencode = prev.opencode.overrideAttrs (oldAttrs:
    {
      node_modules = oldAttrs.node_modules.overrideAttrs (nodeModulesAttrs:
        assert nodeModulesAttrs.outputHash == "sha256-28GpwYLMo2cN4Y9cY6/xn9R5EggFj/m1guuSxsbqisM=";
          (patchPreBuild nodeModulesAttrs) // {outputHash = "sha256-EWS/DKClw1KPZ4iXR+q48QGkSojWy1kgdstUAPh7NaE=";});
    }
    // patchPreBuild oldAttrs
    // patchPostPatch oldAttrs);
}
