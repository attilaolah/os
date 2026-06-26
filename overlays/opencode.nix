_final: prev: let
  useNixpkgsBunVersion = ''
    substituteInPlace package.json \
      --replace-fail \
        '"packageManager": "bun@1.3.14"' \
        '"packageManager": "bun@${prev.bun.version}"'
  '';
  pinGhosttyWeb = ''
    substituteInPlace packages/app/package.json \
      --replace-fail \
        '"ghostty-web": "github:anomalyco/ghostty-web#main"' \
        '"ghostty-web": "github:anomalyco/ghostty-web#20bd361"'
  '';
  omitEmptyMcpArguments = ''
    substituteInPlace packages/opencode/src/mcp/catalog.ts \
      --replace-fail \
        'arguments: (args || {}) as Record<string, unknown>,' \
        'arguments: Object.fromEntries(Object.entries((args || {}) as Record<string, unknown>).filter(([, value]) => value !== "")),'
  '';
  patchPreBuild = attrs: {preBuild = (attrs.preBuild or "") + useNixpkgsBunVersion + pinGhosttyWeb;};
  patchPostPatch = attrs: {postPatch = (attrs.postPatch or "") + omitEmptyMcpArguments;};
in {
  opencode = prev.opencode.overrideAttrs (oldAttrs:
    {node_modules = oldAttrs.node_modules.overrideAttrs patchPreBuild;}
    // patchPreBuild oldAttrs
    // patchPostPatch oldAttrs);
}
