{
  lib,
  pkgs,
}: let
  direnvCommand = {
    name,
    package,
    executable ? name,
  }: let
    app = pkgs.writeShellApplication {
      name = "direnv-${name}";
      runtimeInputs = with pkgs; [
        coreutils
        direnv
        package
      ];
      text = ''
        exec direnv exec "$(pwd)" ${executable} "$@"
      '';
    };
  in "exec ${lib.getExe app}";
in {
  default_tool = "opencode";

  claude.command = direnvCommand {
    name = "claude";
    package = pkgs.claude-code;
  };

  codex.command = direnvCommand {
    name = "codex";
    package = pkgs.codex;
  };

  opencode.command = direnvCommand {
    name = "opencode";
    package = pkgs.opencode;
  };

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
}
