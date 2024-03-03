{ config, lib, pkgs, ... }:

{
  imports = [
    ./file.nix
  ];

  home.username = "ao";
  home.homeDirectory = "/home/ao";
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    # Shell & tools:
    fish
    tmux
    tree
    zoxide
    silver-searcher
    fzf

    # Editors:
    neovim

    # Hyprland deps:
    foot
    waybar
    wofi

    # Utilities:
    curl
    wget
    rsync
    gnupg
    pinentry
    mktemp
    dig
    screenfetch
    age
    any-nix-shell
    direnv
    ripgrep
    fd

    # Development environment:
    git
    bazelisk
    buildifier
    buildozer
    clang
    clang-tools
    clangStdenv
    pkg-config
    gnumake
    cmake
    rustup
    go
    nodejs
    nodePackages.pnpm
    python311Full
    python311Packages.ipython
    ruby
    elan
    android-tools
    virtualenv

    # GUI apps:
    google-chrome
    firefox
    gimp
  ];

  nixpkgs.config.allowUnfree = true;

  home.sessionPath = [
    "${config.home.homeDirectory}/local/bin"
  ];

  home.sessionVariables = {
    # Shell:
    LANG = "en_US.UTF-8";
    LANGUAGE = "en_US:en";
    SHELL = "${pkgs.fish}/bin/fish";
    # Editor:
    EDITOR = "nvim";
    VISUAL = "nvim";
    # Development environment:
    GOPATH = "${config.home.homeDirectory}/dev/go";
    RUSTUP_HOME = "${config.home.homeDirectory}/dev/rustup";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 1800;  # 30m
    pinentryFlavor = "curses";
  };

  programs.fish = {
    enable = true;
    shellAbbrs = {
      "..." = "cd ../..";
      "...." = "cd ../../..";

      l = "ls -lh";
      ll = "ls -la";

      f = "fd";

      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      nv = "nvim";

      bazel = "bazelisk";

      g = "git status";
      ga = "git add -p .";
      gb = "git branch -avv";
      gc = "git commit -v";
      gg = "git commit -m";
      gl = "git log --abbrev-commit --decorate --graph --pretty=oneline";
      gp = "git push";
      gr = "git remote -v";

      c = "curl -s --dump-header /dev/stderr";

      kb-us = "setxkbmap -layout us -option caps:escape";
      kb-dvp = "setxkbmap -layout us -variant dvp -option altwin:meta_win -option caps:escape -option compose:ralt -option keypad:atm -option kpdl:semi -option numpad:shift3";

      nix-try = "nix-shell --run $SHELL --packages";

      # Hyprland is so cool it starts with a capital letter.
      # Nevertheless, nobody likes excessive pinky usage, so let's fix that.
      h = "Hyprland";
    };
    interactiveShellInit = ''
      set --universal fish_greeting
      source ${pkgs.fzf}/share/fish/vendor_functions.d/fzf_key_bindings.fish
      source ${pkgs.fzf}/share/fish/vendor_conf.d/load-fzf-key-bindings.fish
      ${pkgs.zoxide}/bin/zoxide init --cmd cd fish | source
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source
      ${pkgs.direnv}/bin/direnv hook fish | source
    '';
  };

  programs.gpg = {
    enable = true;
    settings = {
      default-key = "07E6C0643FD142C3";
    };
  };

  programs.git = {
    enable = true;
    userName = "Attila Oláh";
    userEmail = "attilaolah@gmail.com";
    signing = {
      signByDefault = true;
      key = "07E6C0643FD142C3";
    };
    aliases = {
      ci = "commit";
      co = "checkout";
    };
    extraConfig = {
      pull = { rebase = true; };
      push = { autoSetupRemote = true; };
      init = { defaultBranch = "main"; };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
