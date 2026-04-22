{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;

    fontconfig = {
      enable = true;
      subpixel.rgba = "rgb"; # centre monitor
      defaultFonts = {
        sansSerif = ["Inter"];
        serif = ["Roboto Serif"];
        monospace = ["JetBrainsMono Nerd Font"];
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
      vista-fonts
    ];
  };
}
