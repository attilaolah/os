{
  config,
  lib,
  pkgs,
  ...
}: {
  fonts = {
    enableDefaultPackages = false;

    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = ["Inter"];
        serif = ["Roboto Serif"];
        monospace = ["TwilioSansM Nerd Font"];
        emoji = ["JoyPixels"];
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
      roboto-serif
    ];
  };

  nixpkgs.config.joypixels.acceptLicense = true;
}
