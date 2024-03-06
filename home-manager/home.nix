{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./file.nix
    ./home/packages.nix
    ./programs/fish.nix
    ./programs/git.nix
    ./programs/gpg.nix
    ./programs/rofi.nix
    ./wayland/window_manager/hyprland.nix
    ./services/gpg_agent.nix
    ./gtk.nix
    ./qt.nix
  ];

  home = {
    username = "ao";
    homeDirectory = "/home/ao";
    stateVersion = "23.11";

    sessionVariables = with config.home; {
      SHELL = "${pkgs.fish}/bin/fish";
      VISUAL = "nvim";

      # Development environment:
      GOPATH = "${homeDirectory}/dev/go";
      RUSTUP_HOME = "${homeDirectory}/dev/rustup";

      # XDG dirs:
      XDG_DESKTOP_DIR = homeDirectory;
      XDG_DOWNLOAD_DIR = "${homeDirectory}/dl";
      XDG_PICTURES_DIR = "${homeDirectory}/photos";
      XDG_PUBLICSHARE_DIR = "${homeDirectory}/p2p";
      XDG_VIDEOS_DIR = "${homeDirectory}/videos";
      # XDG_DOCUMENTS_DIR not set
      # XDG_MUSIC_DIR not set
      # XDG_TEMPLATES_DIR not set
    };
  };

  nixpkgs.config.allowUnfree = true;
}
