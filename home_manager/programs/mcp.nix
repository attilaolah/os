{
  lib,
  pkgs,
  ...
}: let
  disabledByDefault = lib.mapAttrs (_: server: server // {enabled = lib.mkDefault false;});
  googleChromeSupported = lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.google-chrome;
in {
  programs.mcp = {
    enable = true;

    servers = disabledByDefault {
      bitbucket = {
        description = "Bitbucket MCP server";
        command = lib.getExe pkgs.bitbucket-mcp;
      };

      atlassian = {
        description = "Atlassian MCP server";
        command = lib.getExe pkgs.mcp-atlassian;
      };

      flux-operator = {
        description = "Flux Operator MCP server";
        command = lib.getExe pkgs.fluxcd-operator-mcp;
        args = ["serve"];
      };

      kubernetes = {
        description = "Kubernetes MCP server";
        command = lib.getExe pkgs.kubernetes-mcp-server;
      };

      playwright = {
        description = "Playwright MCP server";
        command = lib.getExe pkgs.playwright-mcp;
        env =
          {
            PLAYWRIGHT_MCP_CAPS = "devtools,vision";
            PLAYWRIGHT_MCP_ISOLATED = "1";
          }
          // lib.optionalAttrs googleChromeSupported {
            PLAYWRIGHT_MCP_EXECUTABLE_PATH = lib.getExe pkgs.google-chrome;
          };
      };

      sonarqube = {
        description = "SonarQube MCP server";
        command = lib.getExe pkgs.sonarqube-mcp-server;
      };

      teamcity = {
        description = "TeamCity MCP server";
        command = lib.getExe pkgs.teamcity-mcp;
      };
    };
  };
}
