{
  lib,
  pkgs,
  ...
}: {
  programs.mcp = {
    enable = true;

    servers =
      lib.mapAttrs
      (_: server:
        {
          enabled = lib.mkDefault false;
          command = lib.getExe pkgs.gcf-proxy;
          args = [(lib.getExe server.package)] ++ server.args or [];
        }
        // builtins.removeAttrs server ["args"])
      {
        bitbucket = {
          description = "Bitbucket";
          package = pkgs.bitbucket-mcp;
        };

        codebase-memory = {
          description = "Codebase Memory";
          package = pkgs.codebase-memory-mcp;
        };

        atlassian = {
          description = "Atlassian";
          package = pkgs.mcp-atlassian;
        };

        flux-operator = {
          description = "Flux Operator";
          package = pkgs.fluxcd-operator-mcp;
          args = ["serve"];
        };

        headroom = {
          description = "Headroom";
          package = pkgs.headroom-ai;
          args = ["mcp" "serve"];
          # On by default, because the proxy is also on by default.
          enabled = lib.mkDefault true;
        };

        kubernetes = {
          description = "Kubernetes";
          package = pkgs.kubernetes-mcp-server;
        };

        playwright = let
          browser = pkgs.google-chrome;
        in {
          description = "Playwright";
          package = pkgs.playwright-mcp;
          env =
            {
              PLAYWRIGHT_MCP_CAPS = "devtools,vision";
              PLAYWRIGHT_MCP_ISOLATED = "1";
            }
            // lib.optionalAttrs
            (lib.meta.availableOn pkgs.stdenv.hostPlatform browser)
            {PLAYWRIGHT_MCP_EXECUTABLE_PATH = lib.getExe browser;};
        };

        sonarqube = {
          description = "SonarQube";
          package = pkgs.sonarqube-mcp-server;
        };

        teamcity = {
          description = "TeamCity";
          package = pkgs.teamcity-mcp;
        };
      };
  };
}
