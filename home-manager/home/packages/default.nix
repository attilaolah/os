{
  gpu,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      # GNU tools
      coreutils # cp, mv, rm, etc.
      findutils # find
      gawk # awk
      gnused # sed
      procps # watch
      util-linux # cal, etc.

      # CLI utilities:
      age
      any-nix-shell
      bat
      bitbucket-cli
      claude-code
      colordiff
      curl
      devenv
      dig
      exiftool
      expect
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
      pinentry-tty
      pv
      pwgen
      rar
      rclone
      ripgrep
      rsync
      sops
      subversion
      termshark
      tmux
      tree
      ty
      unzip
      usbutils
      wget
      xkcdpass
      yq-go
      zip
      zoxide

      # NeoVim dependencies:
      alejandra
      black
      cargo
      clang_22
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
      zig
      zls

      # Used by MCP servers currently
      yaml-language-server

      # Virtualisation:
      podman-compose
      podman-tui

      # AI stuff:
      antigravity-cli
      codex
      opencode
      qwen-code

      # Python, the basics:
      (python314.withPackages (ps:
        with ps; [
          huggingface-hub
          jmespath
          polars
          # TODO: add when supported:
          # ipython
        ]))

      # NPM packages:
      # NodeJS runtimes & packages
      bun
      nodejs_26
      pnpm
      prettier
      typescript-language-server

      (llama-cpp.override gpu)
      (import ./restart_sops.nix {inherit lib pkgs;})
    ]
    ++ lib.lists.optionals pkgs.stdenv.isLinux [
      # Not supported on darwin:
      bubblewrap
      traceroute

      # Using podman-compose on darwin instead.
      docker-compose

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
      darktable
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
