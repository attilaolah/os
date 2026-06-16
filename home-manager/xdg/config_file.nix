{
  config,
  lib,
  pkgs,
  ...
}: let
  tomlFormat = pkgs.formats.toml {};
  toINI = lib.generators.toINI {};
in {
  xdg.configFile = let
    inherit (builtins) readFile replaceStrings toJSON;
    inherit (import ../../hosts/home/fonts.nix {inherit pkgs;}) fonts;

    fontSize = 16;
    fontFamily = builtins.elemAt fonts.fontconfig.defaultFonts.monospace 0;
  in
    {
      "nvim/lua/autocmds.lua".source = ./nvim/lua/autocmds.lua;
      "nvim/lua/chadrc.lua".source = ./nvim/lua/chadrc.lua;
      "nvim/lua/configs/conform.lua".source = ./nvim/lua/configs/conform.lua;
      "nvim/lua/configs/lazy.lua".source = ./nvim/lua/configs/lazy.lua;
      "nvim/lua/configs/lspconfig.lua".source = ./nvim/lua/configs/lspconfig.lua;
      "nvim/lua/mappings.lua".source = ./nvim/lua/mappings.lua;
      "nvim/lua/options.lua".source = ./nvim/lua/options.lua;
      "nvim/lua/plugins/init.lua".source = ./nvim/lua/plugins/init.lua;

      "agent-deck/config.toml".source = tomlFormat.generate "agent-deck-config.toml" {
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
          fallback_to_sdio = true;
          show_protocol_status = true;
        };

        mcps = {
          kubernetes = {
            description = "Kubernetes MCP server";
            command = "npx";
            # TODO: write a derivation for this.
            args = ["-y" "kubernetes-mcp-server@latest"];
          };
        };
      };
    }
    // lib.attrsets.optionalAttrs pkgs.stdenv.isDarwin {
      "karabiner/karabiner.json".text = toJSON (import ./karabiner);
      "ghostty/config".text = ''
        font-family = "${fontFamily}"
        font-feature = -liga,-calt
        font-size = ${toString fontSize}
        macos-option-as-alt = true
        keybind = cmd+a=esc:a
        theme = Catppuccin Mocha
      '';
    }
    // lib.attrsets.optionalAttrs pkgs.stdenv.isLinux {
      # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.foot.settings
      "foot/foot.ini".text =
        (toINI {
          main = {
            font = "monospace:size=${toString fontSize}";
            font-size-adjustment = 2;
          };
        })
        # TODO: revert once https://github.com/catppuccin/foot/pull/24 is merged
        + replaceStrings [
          "[colors]"
        ] [
          "[colors-dark]"
        ] (readFile pkgs.catppuccin-foot);

      "davfs.conf".text = ''
        secrets ${config.home.homeDirectory}/.config/davfs.secrets
      '';

      # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.wofi.style
      "wofi/style.css".text =
        replaceStrings [
          "/* DYNAMIC STYLE */"
        ] [
          ''
            font-size: ${toString fontSize}px;
            font-family: "${fontFamily}";
          ''
        ] (readFile ./wofi/style.css);
    };
}
