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
      subpixel.rgba = "rgb";  # centre monitor
      defaultFonts = {
        sansSerif = ["Inter"];
        serif = ["Roboto Serif"];
        monospace = ["TwilioSansM Nerd Font"];
      };
    };

    packages = with pkgs; [
      hack-font
      inter
      joypixels
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      roboto
      roboto-mono
      roboto-serif
      roboto-slab
    ];
  };

  nixpkgs.config.joypixels.acceptLicense = true;
}
