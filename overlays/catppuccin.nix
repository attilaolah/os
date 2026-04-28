final: prev: {
  catppuccin-atuin = prev.stdenv.mkDerivation {
    name = "catppuccin-atuin";
    src = prev.fetchFromGitHub {
      owner = "catppuccin";
      repo = "atuin";
      # renovate: datasource=github-tags depName=catppuccin/atuin
      rev = "abfab12de743aa73cf20ac3fa61e450c4d96380c";
      sha256 = "sha256-t/Pq+hlCcdSigtk5uzw3n7p5ey0oH/D5S8GO/0wlpKA=";
    };
    installPhase = ''
      cp --recursive themes/mocha $out
    '';
  };

  catppuccin-fzf = prev.stdenv.mkDerivation {
    name = "catppuccin-fzf";
    src = prev.fetchFromGitHub {
      owner = "catppuccin";
      repo = "fzf";
      # renovate: datasource=github-tags depName=catppuccin/fzf
      rev = "7c2e05606f2e75840b1ba367b1f997cd919809b3";
      sha256 = "sha256-fs3bOs1vfrtuono0yg1xjTSpzoS5m8ZRMD+CjAp+sDU=";
    };
    installPhase = ''
      cp --recursive themes/catppuccin-fzf-mocha.fish $out
    '';
  };

  catppuccin-foot = prev.stdenv.mkDerivation {
    name = "catppuccin-foot";
    src = prev.fetchFromGitHub {
      owner = "catppuccin";
      repo = "foot";
      # renovate: datasource=github-tags depName=catppuccin/foot
      rev = "8d263e0e6b58a6b9ea507f71e4dbf6870aaf8507";
      sha256 = "sha256-bpGVDESE6Pr7kaFgfAWJ/5KC9mRPlv2ciYwRr6jcIKs=";
    };
    installPhase = ''
      cp --recursive themes/catppuccin-mocha.ini $out
    '';
  };
}
