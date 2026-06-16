{
  lib,
  pkgs,
}: {
  default_tool = "opencode";

  global_search = {
    enabled = true;
    recent_days = 120;
    tier = "auto";
  };

  logs = {
    max_lines = 200000;
    max_size_mb = 256;
    remove_orphans = true;
  };

  # [G]umpe: jump to session.
  hotkeys.switch_session = "ctrl+g";

  updates.check_enabled = true;

  preview = {
    show_output = true;
    show_analytics = false;
    show_notes = false;
    notes_output_split = 0.33;
  };

  maintenance.enabled = true;

  system_stats = {
    enabled = true;
    refresh_seconds = 5;
    format = "compact";
    show = [
      "cpu"
      "disk"
      "gpu"
      "network"
      "ram"
    ];
  };

  ui = {
    footer = "curated";
    show_only_installed_tools = true;
  };

  selfheal = {
    enabled = false;
    per_session_per_window = 0;
    global_per_hour = 0;
  };

  mcp_pool = {
    enabled = true;
    auto_start = true;
    pool_all = true;
    fallback_to_stdio = true;
    show_pool_status = true;
  };

  mcps = {
    bitbucket = {
      description = "Bitbucket MCP server";
      command = lib.getExe pkgs.bitbucket-mcp;
    };

    # TODO: extract the binary and get rid of the Podman wrapper.
    atlassian = {
      description = "Atlassian MCP server";
      command = lib.getExe pkgs.podman;
      args = [
        "run"
        "-i"
        "--rm"
        "-e"
        "CONFLUENCE_API_TOKEN"
        "-e"
        "CONFLUENCE_SPACES_FILTER"
        "-e"
        "CONFLUENCE_URL"
        "-e"
        "CONFLUENCE_USERNAME"
        "-e"
        "JIRA_API_TOKEN"
        "-e"
        "JIRA_PROJECTS_FILTER"
        "-e"
        "JIRA_URL"
        "-e"
        "JIRA_USERNAME"
        "ghcr.io/sooperset/mcp-atlassian"
      ];
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

    # TODO: extract the binary and get rid of the Podman wrapper.
    sonarqube = {
      description = "SonarQube MCP server";
      command = lib.getExe pkgs.podman;
      args = [
        "run"
        "-i"
        "--rm"
        "-e"
        "SONARQUBE_URL"
        "-e"
        "SONARQUBE_TOKEN"
        "docker.io/mcp/sonarqube"
      ];
    };

    teamcity = {
      description = "TeamCity MCP server";
      command = lib.getExe pkgs.teamcity-mcp;
    };
  };
}
