{pkgs, ...}: let
  tmux-window-name = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "window-name";
    version = "unstable-2024-08-30";
    rttpFilePath = "tmux_window_name.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "ofirgall";
      repo = "tmux-window-name";
      rev = "dc97a79ac35a9db67af558bb66b3a7ad41c924e7";
      hash = "sha256-o7ZzlXwzvbrZf/Uv0jHM+FiHjmBO0mI63pjeJwVJEhE=";
    };
  };
in {
  programs.tmux = {
    enable = true;

    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    mouse = true;
    newSession = true;
    prefix = "M-a";
    reverseSplit = true;
    sensibleOnTop = true;

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
      {
        plugin = tmux-window-name;
      }
    ];

    extraConfig = ''
      # M-a a: switch between this & last window.
      bind-key M-a last-window

      # Re-numbber windows on close.
      set-option -g renumber-windows on

      # Set by tmux-vim-navigator.
      unbind -n C-L
    '';
  };
}
