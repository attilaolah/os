{lib, ...}: {
  home.file = {
    # SOPS: https://getsops.io
    ".sops.yaml".text = lib.generators.toYAML {} {
      creation_rules = [
        {pgp = "BF2E475974D388E0E30C960407E6C0643FD142C3";}
      ];
    };

    # ~/.*:
    ".tmux.conf".source = ./src/_.tmux.conf;

    # ~/.config:
    ".config/fish/functions/fish_prompt.fish".source = ./src/_.config/fish/functions/fish_prompt.fish;
    ".config/foot/foot.ini".source = ./src/_.config/foot/foot.ini;
    ".config/nvim/init.lua".source = ./src/_.config/nvim/init.lua;
    ".config/wallpapers/alpeli-1020m.jpg".source = ./src/_.config/wallpapers/alpeli-1020m.jpg;
  };
}
