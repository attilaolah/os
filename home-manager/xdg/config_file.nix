{
  config,
  desktop,
  lib,
  pkgs,
  ...
}: let
  desktopAttrs = attrs: lib.attrsets.optionalAttrs desktop attrs;
  foot-catppuccin-mocha = pkgs.stdenv.mkDerivation {
    name = "foot-catppuccin-mocha";
    # TODO: renovate
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "foot";
      rev = "962ff1a5b6387bc5419e9788a773a080eea5f1e1";
      sha256 = "sha256-eVH3BY2fZe0/OjqucM/IZthV8PMsM9XeIijOg8cNE1Y=";
    };
    installPhase = ''
      cp --recursive themes/catppuccin-mocha.ini $out
    '';
  };
in {
  xdg.configFile =
    {
      "nvim/init.lua".source = ./nvim/init.lua;
      "nvim/lua/autocmds.lua".source = ./nvim/lua/autocmds.lua;
      "nvim/lua/chadrc.lua".source = ./nvim/lua/chadrc.lua;
      "nvim/lua/configs/conform.lua".source = ./nvim/lua/configs/conform.lua;
      "nvim/lua/configs/lazy.lua".source = ./nvim/lua/configs/lazy.lua;
      "nvim/lua/configs/lspconfig.lua".source = ./nvim/lua/configs/lspconfig.lua;
      "nvim/lua/mappings.lua".source = ./nvim/lua/mappings.lua;
      "nvim/lua/options.lua".source = ./nvim/lua/options.lua;
      "nvim/lua/plugins/init.lua".source = ./nvim/lua/plugins/init.lua;
    }
    // desktopAttrs {
      # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.foot.settings
      "foot/foot.ini".text =
        (lib.generators.toINI {} {
          main = {
            font = "monospace:size=16";
            font-size-adjustment = 2;
          };
        })
        + builtins.readFile foot-catppuccin-mocha;

      "davfs.conf".text = ''
        secrets ${config.home.homeDirectory}/.config/davfs.secrets
      '';

      # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.wofi.style
      "wofi/style.css".source = ./wofi/style.css;
    };
}
