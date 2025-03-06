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

      # Ctrl+Alt+Arrow navigation:
      bind -n C-M-Up select-pane -U
      bind -n C-M-Down select-pane -D
      bind -n C-M-Left select-pane -L
      bind -n C-M-Right select-pane -R
    '';
  };
}
