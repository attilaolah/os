_final: prev: {
  opencode = prev.opencode.overrideAttrs (oldAttrs:
    oldAttrs
    // {
      node_modules = oldAttrs.node_modules.overrideAttrs (nodeModulesAttrs: let
        brokenHash =
          if prev.stdenv.hostPlatform.isLinux
          then "sha256-8mOzCscBAuogG4tm8CroqjTX5E5yzCvTobbhKvxQP0U="
          else if prev.stdenv.hostPlatform.isDarwin
          then "sha256-wAea8+jajnMDxZ6XJL+Hsrf0621hwtBtWyD1+dS45dE="
          else nodeModulesAttrs.outputHash;
        outputHash =
          if prev.stdenv.hostPlatform.isLinux
          then "sha256-4vGsS3fXeIYkMbPoUiVkaABgjZmiIF2IG/VwxY58vcw="
          else if prev.stdenv.hostPlatform.isDarwin
          then "sha256-BlpLVz+IPdoxXrE76K5mm74k9ZJbMxu08jT4tb8Lv2s="
          else nodeModulesAttrs.outputHash;
      in
        assert nodeModulesAttrs.outputHash == brokenHash;
          nodeModulesAttrs // {inherit outputHash;});
    });
}
