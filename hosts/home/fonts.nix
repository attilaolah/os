{
  config,
  lib,
  pkgs,
  ...
}: {
  fonts = {
    enableDefaultPackages = true;

    fontconfig = {
      enable = true;
      subpixel.rgba = "rgb"; # centre monitor
      defaultFonts = {
        sansSerif = ["Inter"];
        serif = ["Roboto Serif"];
        monospace = ["JetbrainsMono Nerd Font"];
      };
    };

    packages = with pkgs; [
      hack-font
      inter
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-color-emoji
      roboto
      roboto-mono
      roboto-serif
      roboto-slab
    ];
  };
}
