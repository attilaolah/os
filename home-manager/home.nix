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
  ];

  home = {
    username = "ao";
    homeDirectory = "/home/ao";
    stateVersion = "23.11";

    sessionVariables = {
      SHELL = "${pkgs.fish}/bin/fish";
      VISUAL = "nvim";

      # Development environment:
      GOPATH = "${config.home.homeDirectory}/dev/go";
      RUSTUP_HOME = "${config.home.homeDirectory}/dev/rustup";
    };
  };

  qt = {
    enable = true;

    style.name = "breeze";
    platformTheme = "gnome";
  };

  nixpkgs.config.allowUnfree = true;
}
