{
  lib,
  pkgs,
  ...
}: let
  rofi-configs = pkgs.stdenv.mkDerivation {
    name = "rofi-configs";
    src = pkgs.fetchFromGitHub {
      owner = "adi1090x";
      repo = "rofi";
      rev = "216e4fe5dc7326c43f35936586fc9925f82986c9";
      sha256 = "sha256-KWaA+20fZGhRmvX2g4LlZ0WNNBUSdwO/pUqHy88oiPk=";
    };
    installPhase = ''
      cp --recursive files $out
    '';
  };
in {
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

    # Rofi config collection.
    ".config/rofi".source = rofi-configs.out;
  };
}
