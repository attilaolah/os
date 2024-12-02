{pkgs, ...}: {
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
      corefonts
      hack-font
      inter
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      roboto
      roboto-mono
      roboto-serif
      roboto-slab
      vistafonts
    ];
  };
}
