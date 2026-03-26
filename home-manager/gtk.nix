{
  config,
  pkgs,
  ...
}: let
  theme = {
    name = "Vimix-dark-grey";
    package = pkgs.vimix-gtk-themes.override {
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
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = with config.home.pointerCursor; {
      inherit name size;
    };

    gtk3 = {inherit extraConfig;};
    gtk4 = {inherit theme extraConfig;};
  };
}
