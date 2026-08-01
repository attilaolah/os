{
  config,
  pkgs,
  ...
}: let
  theme = {
    name = "WhiteSur";
    package = pkgs.whitesur-gtk-theme.override {
      themeVariants = ["grey"];
      colorVariants = ["dark"];
    };
  };
  extraConfig.gtk-application-prefer-dark-theme = 1;
in {
  gtk = {
    inherit theme;

    enable = true;

    iconTheme = {
      name = "WhiteSur";
      package = pkgs.whitesur-icon-theme;
    };
    cursorTheme = with config.home.pointerCursor; {
      inherit name size;
    };

    gtk3 = {inherit extraConfig;};
    gtk4 = {inherit theme extraConfig;};
  };
}
