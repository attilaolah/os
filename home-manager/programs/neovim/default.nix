{pkgs, ...}: {
  imports = [
    ../../../hosts/home/programs/neovim.nix
  ];
  programs.neovim = {
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      # Language servers:
      kotlin-language-server
      lua-language-server
      tree-sitter
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
