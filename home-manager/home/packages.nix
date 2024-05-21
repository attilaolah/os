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
      curl
      dig
      direnv
      fastfetch
      fd
      fzf
      gnumake
      gnupg
      gotop
      htop
      jq
      killall
      mktemp
      openssl
      pciutils
      pinentry
      ripgrep
      rsync
      silver-searcher
      sops
      termshark
      tmux
      traceroute
      tree
      usbutils
      wget
      yq
      zoxide

      # NVim:
      neovim
      # NVim dependencies:
      alejandra
      ansible-language-server
      cue
      go
      gofumpt
      gopls
      lua-language-server
      nil
      rust-analyzer
      rustfmt
      stylua
      vscode-langservers-extracted
      yaml-language-server

      # Virtualisation:
      docker-compose
      podman-compose
      podman-tui

      # Python, the basics:
      (python311.withPackages (ps:
        with ps; [
          ipython
          jupyter
          pandas
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
      google-chrome

      # Other GUI apps:
      blender-hip
      discord
      gimp
      inkscape
      pavucontrol
      rawtherapee
      slack
      wireshark

      # Utilities:
      libnotify
      nufraw-thumbnailer
    ]
    ++ desktopList (with gnome; [
      # Gnome apps:
      cheese
      eog
      nautilus
    ]);
}
