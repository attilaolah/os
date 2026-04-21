{
  programs.zsh = {
    enable = true;
    initContent = ''
      if [[ $- == *i* ]] && command -v fish >/dev/null; then
        exec fish
      fi
    '';
  };
}
