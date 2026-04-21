{
  config,
  lib,
  pkgs,
  platform,
  user,
  ...
}: {
  imports =
    [
      ./file.nix
      ./home/packages.nix
      ./programs
      ./services
      ./xdg/config_file.nix
    ]
    ++ lib.lists.optionals (platform == "linux") [
      ./gtk.nix
      ./qt.nix
      ./wayland/window_manager/hyprland.nix
    ];

  home =
    {
      inherit (user) username;
      homeDirectory = "/${
        if (platform == "darwin")
        then "Users"
        else "home"
      }/${user.username}";
      stateVersion = "23.11";

      sessionVariables = with config.home;
        {
          SHELL = lib.getExe pkgs.fish;

          # Development environment:
          GOPATH = "${homeDirectory}/dev/go";
        }
        // lib.attrsets.optionalAttrs (platform == "linux") {
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
    // lib.attrsets.optionalAttrs (platform == "linux") {
      pointerCursor = {
        name = "Adwaita";
        size = 24;
        package = pkgs.adwaita-icon-theme;
        gtk.enable = true;
        x11.enable = true;
      };
    };
}
