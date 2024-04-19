{pkgs, ...}: {
  qt = {
    enable = true;

    style = {
      name = "Adwaita-Dark";
      package = pkgs.adwaita-qt;
    };
    platformTheme.name = "gtk";
  };
}
