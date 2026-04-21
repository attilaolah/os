{lib, ...}: {
  programs.neovim = let
    off = lib.mkDefault false;
  in {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # NixOS 26.05 defaults:
    withPython3 = off;
    withRuby = off;
  };
}
