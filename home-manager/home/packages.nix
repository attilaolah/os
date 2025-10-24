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
      gh
      gnumake
      gnupg
      gotop
      htop
      jira-cli-go
      jq
      killall
      kubectl
      kubernetes-helm
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

      # NeoVim dependencies:
      alejandra
      black
      cargo
      clang_20
      cue
      go
      gofumpt
      gopls
      helm-ls
      ktfmt
      nil
      pyright
      rustc
      rust-analyzer
      rustfmt
      stylua
      usort

      # Virtualisation:
      docker-compose
      podman-compose
      podman-tui

      # AI stuff:
      codex
      gemini-cli
      qwen-code

      # Python, the basics:
      (python314.withPackages (ps:
        with ps; [
          jmespath
          polars
          # TODO: add when supported:
          # ipython
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
