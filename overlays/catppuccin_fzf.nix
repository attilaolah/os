import ./lib/catppuccin_derivation.nix {
  github-tags = ["catppuccin/fzf" "7c2e05606f2e75840b1ba367b1f997cd919809b3"];
  hash-src = "sha256-fs3bOs1vfrtuono0yg1xjTSpzoS5m8ZRMD+CjAp+sDU=";

  extract = theme: "catppuccin-fzf-${theme}.fish";
}
