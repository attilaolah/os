{pkgs, ...}: {
  programs.neovim =
    (import ../../../hosts/home/programs/neovim.nix)
    // {
      extraPackages = with pkgs; [
        # Language servers:
        kotlin-language-server
        lua-language-server
        vscode-langservers-extracted
        yaml-language-server

        # Unmaintained, maybe pick it up.
        # ansible-language-server
      ];
      extraLuaConfig = builtins.readFile ./init.lua;
    };
}
