{
  lib,
  pkgs,
  ...
}: let
  disabledByDefault = lib.mapAttrs (_: server: {enabled = lib.mkDefault false;} // server);
  googleChromeSupported = lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.google-chrome;
in {
  programs.mcp = {
    enable = true;

    servers = disabledByDefault {
      bitbucket = {
        description = "Bitbucket";
        command = lib.getExe pkgs.gcf-proxy;
        args = [
          (lib.getExe pkgs.bitbucket-mcp)
        ];
      };

      codebase-memory-mcp = {
        description = "Codebase Memory";
        command = lib.getExe pkgs.gcf-proxy;
        args = [
          (lib.getExe pkgs.codebase-memory-mcp)
        ];
      };

      atlassian = {
        description = "Atlassian";
        command = lib.getExe pkgs.gcf-proxy;
        args = [
          (lib.getExe pkgs.mcp-atlassian)
        ];
      };

      flux-operator = {
        description = "Flux Operator";
        command = lib.getExe pkgs.gcf-proxy;
        args = [(lib.getExe pkgs.fluxcd-operator-mcp) "serve"];
      };

      headroom = {
        enabled = lib.mkDefault true;
        description = "Headroom";
        command = lib.getExe pkgs.gcf-proxy;
        args = [(lib.getExe pkgs.headroom-ai) "mcp" "serve"];
      };

      kubernetes = {
        description = "Kubernetes";
        command = lib.getExe pkgs.gcf-proxy;
        args = [
          (lib.getExe pkgs.kubernetes-mcp-server)
        ];
      };

      playwright = {
        description = "Playwright";
        command = lib.getExe pkgs.gcf-proxy;
        args = [
          (lib.getExe pkgs.playwright-mcp)
        ];
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
        description = "SonarQube";
        command = lib.getExe pkgs.gcf-proxy;
        args = [
          (lib.getExe pkgs.sonarqube-mcp-server)
        ];
      };

      teamcity = {
        description = "TeamCity";
        command = lib.getExe pkgs.gcf-proxy;
        args = [
          (lib.getExe pkgs.teamcity-mcp)
        ];
      };
    };
  };
}
