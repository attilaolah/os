final: prev: {
  opencv = prev.opencv.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      (prev.fetchpatch {
        url = "https://github.com/opencv/opencv_contrib/commit/054007b78c8288ef2fd040e77dc0cf2e45f70c15.patch";
        hash = "sha256-vDW6kfDmwPB/tTurkDXuvViXrzXYV4njjDN6kLoIvJ4=";
        stripLen = 2;
        extraPrefix = "opencv_contrib/";
      })
    ];
  });
}
