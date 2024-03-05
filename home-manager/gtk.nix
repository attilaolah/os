{pkgs, ...}: {
  gtk = {
    enable = true;

    theme = {
      name = "vimix-dark-doder";
      package = pkgs.vimix-gtk-themes;
    };

    iconTheme = {
      name = "Vimix-dark";
      package = pkgs.vimix-icon-theme;
    };

    cursorTheme = {
      name = "Adwaita";
      size = 30;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
