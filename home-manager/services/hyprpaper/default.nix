# https://mynixos.com/home-manager/options/services.hyprpaper
{
  services.hyprpaper = {
    enable = true;
    settings = let
      default = "${./wallpaper.jpg}";
    in {
      preload = [default];
      wallpaper = [",${default}"];
    };
  };
}
