{
  desktop,
  lib,
  pkgs,
  ...
}: let
  desktopList = list: lib.lists.optionals desktop list;
in {
  home.packages = with pkgs;
    [
      # CLI utilities:
      age
      any-nix-shell
      colordiff
      curl
      devenv
      dig
      fastfetch
      ffmpeg
      file
      fzf
      gnumake
      gnupg
      gotop
      htop
      jq
      killall
      mktemp
      openssl
      p7zip
      pciutils
      pinentry
      pwgen
      rar
      ripgrep
      rsync
      silver-searcher
      sops
      termshark
      tmux
      traceroute
      tree
      unzip
      usbutils
      wget
      yq
      zip
      zoxide

      # NVim:
      neovim
      # NVim dependencies:
      alejandra
      ansible-language-server
      black
      cargo
      clang_19
      cue
      go
      gofumpt
      gopls
      helm-ls
      kotlin-language-server
      ktfmt
      lua-language-server
      nil
      pyright
      rustc
      rust-analyzer
      rustfmt
      stylua
      usort
      vscode-langservers-extracted
      yaml-language-server

      # Virtualisation:
      docker-compose
      podman-compose
      podman-tui

      # Python, the basics
      (python313.withPackages (ps:
        with ps; [
          ipython
          jmespath
          jupyter
          polars
        ]))
    ]
    ++ (with nodePackages; [
      # NPM packages:
      pnpm
      prettier
      typescript-language-server
    ])
    ++ desktopList [
      # Theming:
      vimix-gtk-themes
      vimix-icon-theme

      # Browsers:
      firefox
      google-chrome

      # Other GUI apps:
      discord
      gimp
      inkscape
      pavucontrol
      rawtherapee
      slack
      teams-for-linux
      wireshark

      # Utilities:
      libnotify
      nufraw-thumbnailer

      # Gnome apps:
      cheese
      eog
      file-roller
      nautilus
    ];
}
