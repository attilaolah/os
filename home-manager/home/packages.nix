{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
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
      killall
      mktemp
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

      # NVim:
      neovim
      # NVim dependencies:
      gopls
      lua-language-server stylua
      rust-analyzer rustfmt
      yaml-language-server

      # Desktop utilities:
      pavucontrol
      vimix-gtk-themes
      vimix-icon-theme

      # Browsers:
      firefox
      google-chrome

      # Other GUI apps:
      blender-hip
      gimp
      inkscape
      rawtherapee

      # Virtualisation:
      docker-compose
      podman-compose
      podman-tui

      # Common dev tools.
      # More specific ones should go into per-project flakes.
      android-tools
      bazel_7
      buildifier
      buildozer
      clang
      clang-tools
      clangStdenv
      gnumake
      pkg-config
      cmake
      elan
      go
      nodejs
      ruby
      rustc
      cargo

      # Python:
      (python311.withPackages (ps:
        with ps; [
          ipython
          jupyter
          pandas
        ]))
      virtualenv
    ]
    ++ (with nodePackages; [
      # NPM packages:
      pnpm
      prettier
    ])
    ++ (with gnome; [
      # Gnome apps:
      cheese
      eog
      nautilus
    ]);
}
