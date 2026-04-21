{
  lib,
  platform,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      # GNU tools
      coreutils
      findutils
      gawk
      gnused

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
      silver-searcher
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
      clang
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

      # Virtualisation:
      docker-compose
      podman-compose
      podman-tui

      # AI stuff:
      codex
      gemini-cli
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
      nodejs_25
      pnpm
      prettier
      typescript-language-server
    ]
    ++ lib.lists.optionals (platform == "linux") [
      # Not supported on darwin:
      bubblewrap
      traceroute

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

      # AI (GPU-heavy) tools:
      ((llama-cpp.override {cudaSupport = true;}).overrideAttrs (old: let
        version = "8848";
      in {
        inherit version;
        src = fetchFromGitHub {
          owner = "ggml-org";
          repo = "llama.cpp";
          rev = "b${version}";
          hash = "sha256-QuQW9y8bm43wvBI5lRde08zL5F2nC+aP6Pbm2y8PHUM=";
        };
        npmDepsHash = "sha256-RAFtsbBGBjteCt5yXhrmHL39rIDJMCFBETgzId2eRRk=";
      }))
    ];
}
