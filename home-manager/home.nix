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
      ./file
      ./home/packages
      ./programs
      ./secrets/contact.nix
      ./services
      ./xdg/config_file
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
        if pkgs.stdenv.isDarwin
        then "Users"
        else "home"
      }/${user.username}";
      stateVersion = "23.11";

      sessionVariables = with config.home;
        {
          # Development environment:
          GOPATH = "${homeDirectory}/dev/go";
        }
        // lib.attrsets.optionalAttrs pkgs.stdenv.isDarwin {
          # Use Secretive as the SSH agent on MacOS. It is installed via Homebrew or environment.systemPackages.
          # The GPG-agent based socket can still be used by pointing SSH_AUTH_SOCK to GPG_AGENT_INFO.ssh temporarily.
          SSH_AUTH_SOCK = "${homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
        }
        // lib.attrsets.optionalAttrs pkgs.stdenv.isLinux {
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
    // lib.attrsets.optionalAttrs pkgs.stdenv.isLinux {
      pointerCursor = {
        name = "Adwaita";
        size = 24;
        package = pkgs.adwaita-icon-theme;
        gtk.enable = true;
        x11.enable = true;
      };
    };
}
