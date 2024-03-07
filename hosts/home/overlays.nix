({pkgs, ...}: {
  nixpkgs.overlays = [
    (final: prev: {
      regreet = prev.greetd.regreet.overrideAttrs (old: {
        patches =
          (old.patches or [])
          ++ [
            (pkgs.fetchpatch {
              url = "https://github.com/rharish101/ReGreet/commit/f148a62a33508cd70481fc23999dbbf9c51030a8.patch";
              sha256 = "sha256-SkhchbCSL7P1vq+uEH1v19oy4LImKPY0AtnqhGW7dvc=";
            })
          ];
      });
    })
  ];
})
