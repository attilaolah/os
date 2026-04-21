{
  programs.zsh = {
    enable = true;
    initExtra = ''
      if [[ $- == *i* ]] && command -v fish >/dev/null; then
        exec fish
      fi
    '';
  };
}
