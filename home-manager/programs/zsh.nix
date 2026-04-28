{
  programs.zsh = {
    enable = true;
    # Run in .zshenv so interactive zsh can hand over to fish before the heavier zsh startup stack kicks in.
    envExtra = ''
      if [[ -o interactive ]] && command -v fish >/dev/null; then
        exec fish
      fi
    '';
  };
}
