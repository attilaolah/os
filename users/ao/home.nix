{ config, lib, pkgs, ... }:

{
  imports = [
    ./file.nix
    ./programs/fish.nix
    ./programs/git.nix
    ./programs/gpg.nix
  ];

  home.username = "ao";
  home.homeDirectory = "/home/ao";
  # TODO: Renovate!
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    # Shell & tools:
    tmux
    tree
    zoxide
    silver-searcher
    fzf

    # Editors:
    neovim

    # Hyprland deps:
    foot
    waybar
    wofi

    # Utilities:
    curl
    wget
    rsync
    gnupg
    pinentry
    mktemp
    dig
    screenfetch
    age
    any-nix-shell
    direnv
    ripgrep
    fd

    # Development environment:
    # TODO: Renovate!
    bazel_7
    buildifier
    buildozer
    clang
    clang-tools
    clangStdenv
    pkg-config
    gnumake
    cmake
    rustup
    go
    nodejs
    nodePackages.pnpm
    # TODO: Renovate!
    python311Full
    python311Packages.ipython
    ruby
    elan
    android-tools
    virtualenv

    # GUI apps:
    google-chrome
    firefox
    gimp
  ];

  nixpkgs.config.allowUnfree = true;

  home.sessionPath = [
    "${config.home.homeDirectory}/local/bin"
  ];

  home.sessionVariables = {
    # Shell:
    LANG = "en_US.UTF-8";
    LANGUAGE = "en_US:en";
    SHELL = "${pkgs.fish}/bin/fish";
    # Editor:
    EDITOR = "nvim";
    VISUAL = "nvim";
    # Development environment:
    GOPATH = "${config.home.homeDirectory}/dev/go";
    RUSTUP_HOME = "${config.home.homeDirectory}/dev/rustup";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 1800;  # 30m
    pinentryFlavor = "curses";
  };
}
