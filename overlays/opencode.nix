_final: prev: {
  opencode = prev.opencode.overrideAttrs (oldAttrs:
    {
      node_modules = oldAttrs.node_modules.overrideAttrs (nodeModulesAttrs: let
        brokenHash =
          if prev.stdenv.hostPlatform.isLinux
          then "sha256-U9IuP/ev6w4urvogOwQyl3rdumY6W4YaY18NkFaOVHU="
          else if prev.stdenv.hostPlatform.isDarwin
          then "sha256-wAea8+jajnMDxZ6XJL+Hsrf0621hwtBtWyD1+dS45dE="
          else nodeModulesAttrs.outputHash;
        outputHash =
          if prev.stdenv.hostPlatform.isLinux
          then "sha256-xAnVAOMKE34h6m6jcFQFkNvIAamBHmZdBmX7zjzd6e0="
          else if prev.stdenv.hostPlatform.isDarwin
          then "sha256-BlpLVz+IPdoxXrE76K5mm74k9ZJbMxu08jT4tb8Lv2s="
          else nodeModulesAttrs.outputHash;
      in
        assert nodeModulesAttrs.outputHash == brokenHash;
          nodeModulesAttrs // {inherit outputHash;});
    }
    // oldAttrs);
}
