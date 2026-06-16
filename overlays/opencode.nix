_final: prev: let
  useNixpkgsBunVersion = ''
    sed -i 's/"packageManager": "bun@[^"]*"/"packageManager": "bun@${prev.bun.version}"/' package.json
  '';
  patchPreBuild = attrs: {preBuild = (attrs.preBuild or "") + useNixpkgsBunVersion;};
in {
  opencode = prev.opencode.overrideAttrs (oldAttrs:
    {node_modules = oldAttrs.node_modules.overrideAttrs patchPreBuild;}
    // patchPreBuild oldAttrs);
}
