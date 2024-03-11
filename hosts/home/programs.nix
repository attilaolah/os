{
  pkgs,
  hyprland,
  ...
}: {
  programs = {
    fish.enable = true;
    hyprland = {
      enable = true;
      #package = hyprland.package;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    regreet = {
      enable = true;
      settings = {
        GTK = {
          application_prefer_dark_theme = true;
          cursor_theme_name = "Adwaita";
          icon_theme_name = "Vimix-Black-dark";
          theme_name = "vimix-dark-grey";
        };
      };

      package = pkgs.regreet;
    };
  };
}
