{
  gpu,
  lib,
  platform,
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
      (writeShellApplication {
        name = "restart-sops";
        runtimeInputs =
          [coreutils gnupg gnused]
          ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [systemd];
        text = ''
          gpg-connect-agent UPDATESTARTUPTTY /bye >/dev/null 2>/dev/null

          key="$(
            gpg --list-secret-keys --with-colons 2>/dev/null |
            sed -n 's/^sec:[^:]*:[^:]*:[^:]*:\([^:]*\):.*/\1/p' |
            head -n1
          )"

          if [ -n "$key" ]; then
            printf '%s\n' restart-sops |
              gpg --local-user "$key" --armor --sign --output /dev/null >/dev/null 2>/dev/null
          fi

          ${
            if stdenv.hostPlatform.isDarwin
            then ''launchctl kickstart -k "gui/$(id -u)/org.nix-community.home.sops-nix"''
            else "systemctl --user restart sops-nix.service"
          }
        '';
      })
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

      ((llama-cpp.override gpu).overrideAttrs (old: let
        version = "8884";
      in {
        inherit version;
        src = fetchFromGitHub {
          owner = "ggml-org";
          repo = "llama.cpp";
          rev = "b${version}";
          hash = "sha256-pQvoAIcoYkCI2z93YQP737Zuj3PzpgPGlR5HezRneSE=";
        };
        npmDepsHash = "sha256-RAFtsbBGBjteCt5yXhrmHL39rIDJMCFBETgzId2eRRk=";
      }))
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
    ];
}
