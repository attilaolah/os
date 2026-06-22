_final: prev: let
  useNixpkgsBunVersion = ''
    sed -i 's/"packageManager": "bun@[^"]*"/"packageManager": "bun@${prev.bun.version}"/' package.json
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
    {node_modules = oldAttrs.node_modules.overrideAttrs patchPreBuild;}
    // patchPreBuild oldAttrs
    // patchPostPatch oldAttrs);
}
