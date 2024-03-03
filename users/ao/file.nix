{ lib, ... }:

{
  home.file = {
    # SOPS: https://getsops.io
    ".sops.yaml".text = lib.generators.toYAML {} {
      creation_rules = [
        { pgp = "BF2E475974D388E0E30C960407E6C0643FD142C3"; }
      ];
    };

    # ~/.*:
    ".bash_profile".source = ./src/_.bash_profile;
    ".bashrc".source = ./src/_.bashrc;
    ".hgrc".source = ./src/_.hgrc;
    ".profile".source = ./src/_.profile;
    ".tmux.conf".source = ./src/_.tmux.conf;
    ".zshrc".source = ./src/_.zshrc;

    # ~/.config:
    ".config/fish/functions/fish_prompt.fish".source = ./src/_.config/fish/functions/fish_prompt.fish;
    ".config/foot/foot.ini".source = ./src/_.config/foot/foot.ini;
    ".config/hypr/hyprland.conf".source = ./src/_.config/hypr/hyprland.conf;
    ".config/hypr/hyprpaper.conf".source = ./src/_.config/hypr/hyprpaper.conf;
    ".config/nvim/init.lua".source = ./src/_.config/nvim/init.lua;
    ".config/sway/config".source = ./src/_.config/sway/config;
    ".config/wallpapers/alpeli-1020m.jpg".source = ./src/_.config/wallpapers/alpeli-1020m.jpg;
  };
}
