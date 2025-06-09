{
  config,
  desktop,
  lib,
  pkgs,
  username,
  ...
}: let
  desktopAttrs = attrs: lib.attrsets.optionalAttrs desktop attrs;
  desktopList = list: lib.lists.optionals desktop list;
in {
  imports =
    [
      ./file.nix
      ./home/packages.nix
      ./programs
      ./services
      ./xdg/config_file.nix
    ]
    ++ desktopList [
      ./gtk.nix
      ./qt.nix
      ./wayland/window_manager/hyprland.nix
    ];

  home =
    {
      inherit username;
      homeDirectory = "/home/${username}";
      stateVersion = "23.11";

      sessionVariables = with config.home;
        {
          SHELL = lib.getExe pkgs.fish;
          VISUAL = lib.getExe' pkgs.neovim "nvim";

          # Development environment:
          GOPATH = "${homeDirectory}/dev/go";
        }
        // desktopAttrs
        {
          # XDG dirs:
          XDG_DESKTOP_DIR = homeDirectory;
          XDG_DOWNLOAD_DIR = "${homeDirectory}/dl";
          XDG_PICTURES_DIR = "${homeDirectory}/photos";
          XDG_PUBLICSHARE_DIR = "${homeDirectory}/share";
          XDG_VIDEOS_DIR = "${homeDirectory}/videos";
          # XDG_DOCUMENTS_DIR not set
          # XDG_MUSIC_DIR not set
          # XDG_TEMPLATES_DIR not set
        };
    }
    // desktopAttrs {
      pointerCursor = {
        name = "Adwaita";
        size = 24;
        package = pkgs.adwaita-icon-theme;
        gtk.enable = true;
        x11.enable = true;
      };
    };
}
