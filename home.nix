{ config, lib, pkgs, ... }:

{
  home.username = "atl";
  home.homeDirectory = "/home/atl";
  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    # Shell & tools:
    fish
    tmux
    tree
    silver-searcher
    fzf

    # Editor:
    neovim

    # Utilities:
    curl
    wget
    rsync

    # Development environment:
    git
    bazel
    bazel-watcher
    clang
    clang-tools
    rustc
    cargo
    rustfmt
    go
    nodejs
    python3
    python3Packages.ipython
    ruby
  ];

  home.sessionPath = [
    "${config.home.homeDirectory}/dev/bin"
    "${config.home.homeDirectory}/dev/cargo/bin"
    "${config.home.homeDirectory}/dev/go/bin"
  ];

  home.file = {
    # ~/.config:
    ".config/fish/functions/fish_prompt.fish".source = ./src/_.config/fish/functions/fish_prompt.fish;
    # ~/.*:
    ".bash_profile".source = ./src/_.bash_profile;
    ".bashrc".source = ./src/_.bashrc;
    ".gitconfig".source = ./src/_.gitconfig;
    ".hgrc".source = ./src/_.hgrc;
    ".profile".source = ./src/_.profile;
    ".tmux.conf".source = ./src/_.tmux.conf;
    ".zshrc".source = ./src/_.zshrc;
  };

  home.sessionVariables = {
    # Shell:
    LANG = "en_US.UTF-8";
    LANGUAGE = "en_US:en";
    SHELL = "${pkgs.fish}/bin/fish";
    # Editor:
    EDITOR = "nvim";
    VISUAL = "nvim";
    # Development environment:
    CARGO_HOME = "${config.home.homeDirectory}/dev/cargo";
    GOHOME = "${config.home.homeDirectory}/dev/go";
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;  # 30m
    enableSshSupport = true;
  };

  programs.fish = {
    enable = true;
    shellAbbrs = {
      "..." = "cd ../..";
      "...." = "cd ../../..";

      l = "ls -lh";
      ll = "ls -la";

      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      nv = "nvim";

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
    };
    interactiveShellInit = ''
      set --universal fish_greeting
      source ${pkgs.fzf}/share/fish/vendor_functions.d/fzf_key_bindings.fish
      source ${pkgs.fzf}/share/fish/vendor_conf.d/load-fzf-key-bindings.fish
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
