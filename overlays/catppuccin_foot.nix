import ./lib/catppuccin_derivation.nix {
  github-tags = ["catppuccin/foot" "8d263e0e6b58a6b9ea507f71e4dbf6870aaf8507"];
  hash-src = "sha256-bpGVDESE6Pr7kaFgfAWJ/5KC9mRPlv2ciYwRr6jcIKs=";

  extract = theme: "catppuccin-${theme}.ini";
}
