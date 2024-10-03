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
      vim-tmux-navigator
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_status_left_separator "█"
          set -g @catppuccin_status_right_separator "█"
        '';
      }
    ];

    extraConfig = ''
      # M-a a: switch between this & last window.
      bind-key M-a last-window

      # Re-numbber windows on close.
      set-option -g renumber-windows on

      # Undo tmux-vim-navigator binding.
      unbind -n C-l
    '';
  };
}
