{ config, lib, pkgs, ... }:

{
  imports = [
    ./file.nix
    ./home/packages.nix
    ./programs/fish.nix
    ./programs/git.nix
    ./programs/gpg.nix
  ];

  home = {
    username = "ao";
    homeDirectory = "/home/ao";
    # TODO: Renovate!
    stateVersion = "23.11";

    sessionVariables = {
      # Shell:
      #LANG = "en_US.UTF-8";
      #LANGUAGE = "en_US:en";
      SHELL = "${pkgs.fish}/bin/fish";
      # Editor:
      #EDITOR = "nvim";
      VISUAL = "nvim";
      # Development environment:
      GOPATH = "${config.home.homeDirectory}/dev/go";
      RUSTUP_HOME = "${config.home.homeDirectory}/dev/rustup";
    };
  };


  nixpkgs.config.allowUnfree = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 1800;  # 30m
    pinentryFlavor = "curses";
  };
}
