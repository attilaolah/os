{pkgs, ...}: {
  home.file.".terminfo" = {
    # https://ghostty.org/docs/help/terminfo
    source = "${pkgs.ghostty.terminfo}/share/terminfo";
    recursive = true;
  };
}
