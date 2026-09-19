_final: prev: {
  opencode = prev.opencode.overrideAttrs (oldAttrs:
    oldAttrs
    // {
      node_modules = oldAttrs.node_modules.overrideAttrs (nodeModulesAttrs: let
        brokenHash =
          if prev.stdenv.hostPlatform.isLinux
          then "sha256-8mOzCscBAuogG4tm8CroqjTX5E5yzCvTobbhKvxQP0U="
          else if prev.stdenv.hostPlatform.isDarwin
          then "sha256-YY5A/zxLPONvgnI+DZlzcD2K5Q9PIw4F2YbDxKbT4UU="
          else nodeModulesAttrs.outputHash;
        outputHash =
          if prev.stdenv.hostPlatform.isLinux
          then "sha256-4vGsS3fXeIYkMbPoUiVkaABgjZmiIF2IG/VwxY58vcw="
          else if prev.stdenv.hostPlatform.isDarwin
          then "sha256-+Bon3V9z60OdjlD4edi8I4Hua8z7mDaY6pyAXOpEutg="
          else nodeModulesAttrs.outputHash;
      in
        assert nodeModulesAttrs.outputHash == brokenHash;
          nodeModulesAttrs // {inherit outputHash;});
    });
}
