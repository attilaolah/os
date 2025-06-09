{
  services.hyprpaper = {
    enable = true;
    settings = let
      default = "$XDG_CONFIG_DIR/wallpaper.jpg";
    in {
      preload = [default];
      wallpaper = [",${default}"];
    };
  };
}
