{
  programs.fish.shellAbbrs = let
    np = "nix-shell --packages";
    nr = "nixpkg-run";
  in {
    "..." = "cd ../..";
    "...." = "cd ../../..";
    ":q" = "exit";

    l = "ls -lh";
    ll = "ls -la";
    f = "fd";
    r = "rg";
    t = "tree";
    tm = "tmx";

    v = "nvim";

    c = "curl -D/dev/stderr -s";
    k = "kubectl";

    g = "git status";
    ga = "git add -p .";
    gb = "git branch -avv";
    gc = "git commit -v";
    gg = "git commit -m";
    gp = "git push";
    gr = "git remote -v";
    gl = "git l";
    gll = "git ll";

    inherit np nr;
    nix-try = np;
    nt = np;
  };
}
