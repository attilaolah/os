{
  programs.fish.shellAbbrs = {
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

    nt = "nix-shell --packages";
    nx = "nixpkg-run";
  };
}
