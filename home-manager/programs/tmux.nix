{pkgs, ...}: {
  programs.tmux = {
    enable = true;

    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    mouse = true;
    prefix = "M-a";
    reverseSplit = true;
    sensibleOnTop = true;
    terminal = "screen-256color";

    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
      {
        plugin = vim-tmux-navigator;
        extraConfig = ''
          set -g @vim_navigator_mapping_up "C-M-Up"
          set -g @vim_navigator_mapping_down "C-M-Down"
          set -g @vim_navigator_mapping_left "C-M-Left"
          set -g @vim_navigator_mapping_right "C-M-Right"

          set -g @vim_navigator_prefix_mapping_clear_screen ""
        '';
      }
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_status_left_separator "█"
          set -g @catppuccin_status_right_separator "█"

          set-option -g @catppuccin_window_text " #{=2:pane_current_command}|#{b:pane_current_path}"
          set-option -g @catppuccin_window_current_text " #{=2:pane_current_command}|#{b:pane_current_path}"

          set  -g status-left  ""
          set  -g status-right "#{E:@catppuccin_status_application}"
          set -ag status-right "#{E:@catppuccin_status_session}"
          set -ag status-right "#{E:@catppuccin_status_host}"
        '';
      }
    ];

    extraConfig = ''
      # M-a (twice): switch between this & last window.
      bind-key M-a last-window

      # Re-numbber windows on close.
      set-option -g renumber-windows on
    '';
  };
}
