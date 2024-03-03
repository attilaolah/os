{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # CLI utilities:
    age
    any-nix-shell
    curl
    dig
    direnv
    fd
    fzf
    gnupg
    mktemp
    neovim
    pinentry
    ripgrep
    rsync
    screenfetch
    silver-searcher
    tmux
    tree
    wget
    zoxide

    # Hyprland deps:
    foot
    waybar
    wofi

    # Browsers:
    firefox
    google-chrome

    # Other GUI apps:
    gimp
    inkscape
    rawtherapee

    # Common dev tools.
    # More specific ones should go into per-project flakes.
    android-tools
    # TODO: Renovate!
    bazel_7
    buildifier
    buildozer
    clang
    clang-tools
    clangStdenv
    cmake
    elan
    gnumake
    go
    nodePackages.pnpm
    nodejs
    pkg-config
    # TODO: Renovate!
    (python311.withPackages (ps: with ps; [ ipython ]))
    ruby
    rustup
    virtualenv
  ];
}
