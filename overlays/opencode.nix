_final: prev: {
  opencode = prev.opencode.overrideAttrs (oldAttrs:
    oldAttrs
    // {
      node_modules = oldAttrs.node_modules.overrideAttrs (nodeModulesAttrs: let
        brokenHash =
          if prev.stdenv.hostPlatform.isLinux
          then "sha256-+Clo0VPDdruHSoBNvV/wKAM8iR6HJPtB00oa8yl9ujU="
          else if prev.stdenv.hostPlatform.isDarwin
          then "sha256-pThjoD6baddQ6biy7k1ByXwGwLAeWe/+w0tcYmt1uWs="
          else nodeModulesAttrs.outputHash;
        outputHash =
          if prev.stdenv.hostPlatform.isLinux
          then prev.lib.fakeHash
          else if prev.stdenv.hostPlatform.isDarwin
          then prev.lib.fakeHash
          else nodeModulesAttrs.outputHash;
      in
        assert nodeModulesAttrs.outputHash == brokenHash;
          nodeModulesAttrs // {inherit outputHash;});
    });
}
