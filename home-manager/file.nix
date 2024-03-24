{
  config,
  desktop,
  lib,
  pkgs,
  ...
}: let
  desktopAttrs = attrs: lib.attrsets.optionalAttrs desktop attrs;
in {
  home.file =
    {
      ".sops.yaml".text = lib.generators.toYAML {} {
        creation_rules = [
          {pgp = "BF2E475974D388E0E30C960407E6C0643FD142C3";}
        ];
      };
      # TODO: Use xdg.configFile!
      ".config/tmux/tmux.conf".source = ./.config/tmux/tmux.conf;
      ".config/fish/functions/fish_prompt.fish".source = ./.config/fish/functions/fish_prompt.fish;
      ".config/nvim/init.lua".source = ./.config/nvim/init.lua;
      ".config/nvim/lua/chadrc.lua".source = ./.config/nvim/lua/chadrc.lua;
      ".config/nvim/lua/configs/conform.lua".source = ./.config/nvim/lua/configs/conform.lua;
      ".config/nvim/lua/configs/lazy.lua".source = ./.config/nvim/lua/configs/lazy.lua;
      ".config/nvim/lua/configs/lspconfig.lua".source = ./.config/nvim/lua/configs/lspconfig.lua;
      ".config/nvim/lua/mappings.lua".source = ./.config/nvim/lua/mappings.lua;
      ".config/nvim/lua/options.lua".source = ./.config/nvim/lua/options.lua;
      ".config/nvim/lua/plugins/init.lua".source = ./.config/nvim/lua/plugins/init.lua;
    }
    // desktopAttrs (let
      rofi-configs = pkgs.stdenv.mkDerivation {
        name = "rofi-configs";
        src = pkgs.fetchFromGitHub {
          owner = "adi1090x";
          repo = "rofi";
          rev = "216e4fe5dc7326c43f35936586fc9925f82986c9";
          sha256 = "sha256-KWaA+20fZGhRmvX2g4LlZ0WNNBUSdwO/pUqHy88oiPk=";
        };
        installPhase = ''
          cp --recursive files $out
        '';
      };

      brightnessctl = lib.getExe pkgs.brightnessctl;
      hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
      hyprlock = lib.getExe pkgs.hyprlock;
      loginctl = lib.getExe' pkgs.systemd "loginctl";
      pidof = lib.getExe' pkgs.procps "pidof";
    in {
      # TODO: Use xdg.configFile!
      ".config/foot/foot.ini".text = lib.generators.toINI {} {
        main = {
          font = "monospace:size=16";
          font-size-adjustment = 2;
        };
      };

      ".config/rofi".source = rofi-configs.out;

      ".config/hypr/hypridle.conf".text = ''
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
          timeout = ${toString (60 * 10)}
          on-timeout = ${hyprctl} dispatch dpms off
          on-resume = ${hyprctl} dispatch dpms on
        }
        listener {
          timeout = ${toString (60 * 10 + 20)}
          on-timeout = ${loginctl} lock-session
        }
      '';

      ".config/davfs.conf".text = ''
        secrets ${config.home.homeDirectory}/.config/davfs.secrets
      '';

      # Wallpaper:
      ".config/wallpapers/alpeli-1020m.jpg".source = ./.config/wallpapers/alpeli-1020m.jpg;
    });
}
