{
  config,
  lib,
  pkgs,
  platform,
  ...
}: let
  foot-catppuccin-mocha = pkgs.stdenv.mkDerivation {
    name = "foot-catppuccin-mocha";
    # TODO: renovate
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "foot";
      rev = "8d263e0e6b58a6b9ea507f71e4dbf6870aaf8507";
      sha256 = "sha256-bpGVDESE6Pr7kaFgfAWJ/5KC9mRPlv2ciYwRr6jcIKs=";
    };
    installPhase = ''
      cp --recursive themes/catppuccin-mocha.ini $out
    '';
  };

  toINI = lib.generators.toINI {};
in {
  xdg.configFile = let
    inherit (builtins) readFile replaceStrings;
    inherit (import ../../hosts/home/fonts.nix {inherit pkgs;}) fonts;

    fontSize = 16;
    fontFamily = builtins.elemAt fonts.fontconfig.defaultFonts.monospace 0;
  in
    {
      "nvim/lua/autocmds.lua".source = ./nvim/lua/autocmds.lua;
      "nvim/lua/chadrc.lua".source = ./nvim/lua/chadrc.lua;
      "nvim/lua/configs/conform.lua".source = ./nvim/lua/configs/conform.lua;
      "nvim/lua/configs/lazy.lua".source = ./nvim/lua/configs/lazy.lua;
      "nvim/lua/configs/lspconfig.lua".source = ./nvim/lua/configs/lspconfig.lua;
      "nvim/lua/mappings.lua".source = ./nvim/lua/mappings.lua;
      "nvim/lua/options.lua".source = ./nvim/lua/options.lua;
      "nvim/lua/plugins/init.lua".source = ./nvim/lua/plugins/init.lua;
    }
    // lib.attrsets.optionalAttrs (platform == "darwin") {
      "ghostty/config".text = ''
        font-family = "${fontFamily}"
        font-feature = -liga,-calt
        font-size = ${toString fontSize}
        macos-option-as-alt = true
        keybind = cmd+a=esc:a
        theme = Catppuccin Mocha
      '';
    }
    // lib.attrsets.optionalAttrs (platform == "linux") {
      # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.foot.settings
      "foot/foot.ini".text =
        (toINI {
          main = {
            font = "monospace:size=${toString fontSize}";
            font-size-adjustment = 2;
          };
        })
        # TODO: revert once https://github.com/catppuccin/foot/pull/24 is merged
        + replaceStrings [
          "[colors]"
        ] [
          "[colors-dark]"
        ] (readFile foot-catppuccin-mocha);

      "davfs.conf".text = ''
        secrets ${config.home.homeDirectory}/.config/davfs.secrets
      '';

      # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.wofi.style
      "wofi/style.css".text =
        replaceStrings [
          "/* DYNAMIC STYLE */"
        ] [
          ''
            font-size: ${toString fontSize}px;
            font-family: "${fontFamily}";
          ''
        ] (readFile ./wofi/style.css);
    };
}
