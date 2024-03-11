{
  config,
  pkgs,
  ...
}: {
  gtk = {
    enable = true;

    theme = {
      name = "vimix-dark-grey";
      package = pkgs.vimix-gtk-themes.override {
        themeVariants = ["grey"];
        colorVariants = ["dark"];
      };
    };

    iconTheme = {
      name = "Vimix-Black-dark";
      package = pkgs.vimix-icon-theme;
    };

    cursorTheme = with config.home.pointerCursor; {
      inherit name size;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
