{
  config,
  lib,
  pkgs,
  hypridle,
  hyprlock,
  inputs,
  ...
}: {
  imports = [
    ./file.nix
    ./home/packages.nix
    ./programs/firefox.nix
    ./programs/fish.nix
    ./programs/git.nix
    ./programs/gpg.nix
    ./programs/rofi.nix
    #./programs/hyprlock.nix
    ./wayland/window_manager/hyprland.nix
    ./services/gpg_agent.nix
    ./services/hypridle.nix
    ./gtk.nix
    ./qt.nix
    #hyprlock.homeManagerModules.default
    #inputs.hypridle.homeManagerModules.default
  ];

  home = {
    username = "ao";
    homeDirectory = "/home/ao";
    stateVersion = "23.11";

    sessionVariables = with config.home; {
      SHELL = lib.getExe pkgs.fish;
      VISUAL = lib.getExe' pkgs.neovim "nvim";

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

    pointerCursor = {
      name = "Adwaita";
      size = 24;
      package = pkgs.gnome.adwaita-icon-theme;
      gtk.enable = true;
      x11.enable = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
}
