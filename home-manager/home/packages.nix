{
  config,
  lib,
  pkgs,
  ...
}: {
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
    gotop
    htop
    mktemp
    neovim
    pinentry
    ripgrep
    rsync
    screenfetch
    silver-searcher
    sops
    tmux
    traceroute
    tree
    usbutils
    wget
    zoxide

    # Desktop utilities:
    foot
    pavucontrol
    waybar
    wofi

    # Browsers:
    firefox
    google-chrome

    # Other GUI apps:
    gimp
    inkscape
    rawtherapee
    gnome.cheese

    # Common dev tools.
    # More specific ones should go into per-project flakes.
    android-tools
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
    ruby
    rustup
    virtualenv

    # Python:
    (python312.withPackages (ps: with ps; [ipython]))
  ];
}
