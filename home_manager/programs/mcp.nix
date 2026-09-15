{
  lib,
  pkgs,
  ...
}: {
  programs.mcp = {
    enable = true;

    servers =
      lib.mapAttrs
      (description: server:
        {
          inherit description;
          enabled = lib.mkDefault false;
          command = lib.getExe pkgs.gcf-proxy;
          args = [(lib.getExe server.package)] ++ server.args or [];
        }
        // builtins.removeAttrs server ["args" "package"])
      {
        Headroom = {
          package = pkgs.headroom-ai;
          args = ["mcp" "serve"];
          # Necessary as the proxy is also on by default.
          enabled = lib.mkDefault true;
        };
        "Codebase Memory" = {
          package = pkgs.codebase-memory-mcp;
          # Relatively cheap and starts quickly.
          enabled = lib.mkDefault true;
        };

        Atlassian.package = pkgs.mcp-atlassian;
        Bitbucket.package = pkgs.bitbucket-mcp;
        Kubernetes.package = pkgs.kubernetes-mcp-server;
        SonarQube.package = pkgs.sonarqube-mcp-server;
        TeamCity.package = pkgs.teamcity-mcp;

        "Flux Operator" = {
          package = pkgs.fluxcd-operator-mcp;
          args = ["serve"];
        };

        Playwright = let
          browser = pkgs.google-chrome;
        in {
          package = pkgs.playwright-mcp;
          env =
            {
              PLAYWRIGHT_MCP_CAPS = lib.concatStringsSep "," [
                "devtools"
                "network"
                "pdf"
                "storage"
                "testing"
                "vision"
              ];
              PLAYWRIGHT_MCP_ISOLATED = "1";
            }
            // lib.optionalAttrs
            (lib.meta.availableOn pkgs.stdenv.hostPlatform browser)
            {PLAYWRIGHT_MCP_EXECUTABLE_PATH = lib.getExe browser;};
        };
      };
  };
}
