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
      fd
      fzf
      gnupg
      gotop
      htop
      killall
      mktemp
      pciutils
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
      alejandra
      ansible-language-server
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
      slack
    ]
    ++ desktopList (with gnome; [
      # Gnome apps:
      cheese
      eog
      nautilus
    ]);
}
