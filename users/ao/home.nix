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
    stateVersion = "23.11";

    sessionVariables = {
      SHELL = "${pkgs.fish}/bin/fish";
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
    defaultCacheTtl = 7200;  # 2h
    pinentryFlavor = "curses";
  };
}
