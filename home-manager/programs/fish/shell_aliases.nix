{
  programs.fish.shellAliases = {
    tmx = "tmux new-session -A -s //(whoami)@(hostname -s)/$SHLVL";
  };
}
