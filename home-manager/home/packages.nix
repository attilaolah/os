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
      bitbucket-cli
      bun
      colordiff
      curl
      devenv
      dig
      exiftool
      fastfetch
      ffmpeg
      file
      fzf
      gh
      gnumake
      gnupg
      gotop
      htop
      jira-cli-go
      jq
      killall
      mktemp
      nixpkgs-review
      openssl
      p7zip
      pciutils
      pinentry
      pwgen
      rar
      rclone
      ripgrep
      rsync
      silver-searcher
      sops
      subversion
      termshark
      tmux
      traceroute
      tree
      ty
      unzip
      usbutils
      wget
      yq-go
      zip
      zoxide

      # NVim:
      neovim
      # NVim dependencies:
      alejandra
      # Unmaintained, maybe pick it up.
      # ansible-language-server
      black
      cargo
      clang_20
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

      # AI stuff:
      codex
      gemini-cli
      # qwen-code: https://github.com/nixos/nixpkgs/issues/427851

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
      gsettings-desktop-schemas
      dconf-editor
      glib

      # Browsers:
      firefox
      google-chrome

      # Other GUI apps:
      discord
      foot
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
