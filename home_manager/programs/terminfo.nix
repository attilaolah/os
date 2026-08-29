{pkgs, ...}: {
  # Ghostty is not installed on this host, but it runs on the SSH client
  # (e.g. the work Mac), which advertises `TERM=xterm-ghostty`. That terminfo
  # entry is not part of a default NixOS install, so `tmux attach` over SSH
  # fails with "missing or unsuitable terminal: xterm-ghostty".
  # Populate `$HOME/.terminfo`, the user-level database ncurses (and therefore
  # tmux) searches first, so no `environment.systemPackages` change is needed:
  # https://ghostty.org/docs/help/terminfo
  home.file.".terminfo" = {
    source = "${pkgs.ghostty.terminfo}/share/terminfo";
    recursive = true;
  };
}
