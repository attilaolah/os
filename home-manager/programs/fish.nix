{
  desktop,
  lib,
  pkgs,
  ...
}: let
  desktopAttrs = attrs: lib.attrsets.optionalAttrs desktop attrs;
in {
  programs.fish = {
    enable = true;

    shellAbbrs =
      {
        "..." = "cd ../..";
        "...." = "cd ../../..";
        ":q" = "exit";

        l = "ls -lh";
        ll = "ls -la";
        f = "fd";
        t = "tree";

        v = "nvim";
        vi = "nvim";
        vim = "nvim";
        nv = "nvim";
        nvi = "nvim";

        c = "curl -s --dump-header /dev/stderr";

        g = "git status";
        ga = "git add -p .";
        gb = "git branch -avv";
        gc = "git commit -v";
        gg = "git commit -m";
        gp = "git push";
        gr = "git remote -v";
        gl = "git l";

        n = "nix-pkg-run";
        nix-try = "nix-shell --packages";
      }
      // desktopAttrs {
        kb-us = "setxkbmap -layout us -option caps:escape";
        kb-dvp = "setxkbmap -layout us -variant dvp -option altwin:meta_win -option caps:escape -option compose:ralt -option keypad:atm -option kpdl:semi -option numpad:shift3";
      };

    functions = {
      nix-pkg-run = "nix run nixpkgs#$argv[1] -- $argv[2..]";
    };

    interactiveShellInit = with lib; ''
      set --universal fish_greeting
      source ${pkgs.fzf}/share/fish/vendor_functions.d/fzf_key_bindings.fish
      source ${pkgs.fzf}/share/fish/vendor_conf.d/load-fzf-key-bindings.fish
      ${getExe pkgs.zoxide} init --cmd cd fish | source
      ${getExe pkgs.any-nix-shell} fish | source
      ${getExe pkgs.direnv} hook fish | source
    '';
  };
}
