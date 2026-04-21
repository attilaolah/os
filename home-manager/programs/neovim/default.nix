{pkgs, ...}: {
  programs.neovim =
    # Defaults defined in the hosts file:
    (import ../../../hosts/home/programs/neovim.nix).programs.neovim
    # Overrides:
    // {
      vimdiffAlias = true;
      extraPackages = with pkgs; [
        # Language servers:
        kotlin-language-server
        lua-language-server
        vscode-langservers-extracted
        yaml-language-server

        # Unmaintained, maybe pick it up.
        # ansible-language-server
      ];
      initLua = builtins.readFile ./init.lua;

      # Enable additional language support in the version installed by home-manager.
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
}
