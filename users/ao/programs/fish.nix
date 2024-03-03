{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    shellAbbrs = {
      "..." = "cd ../..";
      "...." = "cd ../../..";
      ":q" = "exit";

      l = "ls -lh";
      ll = "ls -la";
      f = "fd";
      t = "tree";

      v = "nvim";
      nv = "nvim";

      c = "curl -s --dump-header /dev/stderr";

      g = "git status";
      ga = "git add -p .";
      gb = "git branch -avv";
      gc = "git commit -v";
      gg = "git commit -m";
      gl = "git log --abbrev-commit --decorate --graph --pretty=oneline";
      gp = "git push";
      gr = "git remote -v";

      kb-us = "setxkbmap -layout us -option caps:escape";
      kb-dvp = "setxkbmap -layout us -variant dvp -option altwin:meta_win -option caps:escape -option compose:ralt -option keypad:atm -option kpdl:semi -option numpad:shift3";

      n = "nix-pkg-run";
      nix-try = "nix-shell --packages";

      # Hyprland is so cool it starts with a capital letter.
      # Nevertheless, nobody likes excessive pinky usage, so let's fix that.
      h = "Hyprland";
    };

    functions = {
      nix-pkg-run = "nix run nixpkgs#$argv[1] -- $argv[2..]";
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
}
