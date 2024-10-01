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
      rev = "ee5549af72ab78520ac2aa1c671bf5c2d347c8ca";
      sha256 = "sha256-3hK9klXwdHhprG2wUMt7nBfbL1mb/gl+k/MtJUuY000=";
    };
    installPhase = ''
      cp --recursive catppuccin-mocha.ini $out
    '';
  };
in {
  xdg.configFile =
    {
      "hypr/hyprlock.conf".source = ./hypr/hyprlock.conf;
      "nvim/init.lua".source = ./nvim/init.lua;
      "nvim/lua/chadrc.lua".source = ./nvim/lua/chadrc.lua;
      "nvim/lua/configs/conform.lua".source = ./nvim/lua/configs/conform.lua;
      "nvim/lua/configs/lazy.lua".source = ./nvim/lua/configs/lazy.lua;
      "nvim/lua/configs/lspconfig.lua".source = ./nvim/lua/configs/lspconfig.lua;
      "nvim/lua/mappings.lua".source = ./nvim/lua/mappings.lua;
      "nvim/lua/options.lua".source = ./nvim/lua/options.lua;
      "nvim/lua/plugins/init.lua".source = ./nvim/lua/plugins/init.lua;
    }
    // desktopAttrs (let
      brightnessctl = lib.getExe pkgs.brightnessctl;
      hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
      hyprlock = lib.getExe pkgs.hyprlock;
      loginctl = lib.getExe' pkgs.systemd "loginctl";
      pidof = lib.getExe' pkgs.procps "pidof";
    in {
      # TODO: Use xdg.configFile!
      "foot/foot.ini".text =
        (lib.generators.toINI {} {
          main = {
            font = "monospace:size=16";
            font-size-adjustment = 2;
          };
        })
        + builtins.readFile foot-catppuccin-mocha;

      "hypr/hypridle.conf".text = ''
        general {
          lock_cmd = ${pidof} ${hyprlock} || ${hyprlock}
          before_sleep_cmd = ${loginctl} lock-session
          after_sleep_cmd = ${hyprctl} dispatch dpms on
        }

        listener {
          timeout = ${toString (60 * 2)}
          on-timeout = ${brightnessctl} --save set 5%
          on-resume = ${brightnessctl} --restore
        }
        listener {
          timeout = ${toString (60 * 20)}
          on-timeout = ${hyprctl} dispatch dpms off
          on-resume = ${hyprctl} dispatch dpms on
        }
      '';
      # TODO: re-enable!
      # listener {
      #   timeout = ${toString (60 * 20 + 20)}
      #   on-timeout = ${loginctl} lock-session
      # }

      "davfs.conf".text = ''
        secrets ${config.home.homeDirectory}/.config/davfs.secrets
      '';

      "wofi/style.css".source = ./wofi/style.css;
    });
}
