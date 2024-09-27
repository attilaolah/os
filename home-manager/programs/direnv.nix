{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
    config = {
      hide_env_diff = true;
      warn_timeout = "20s";
    };
  };
}
