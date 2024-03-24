{
  lib,
  pkgs,
  ...
}: {
  programs.rofi = {
    enable = true;

    plugins = with pkgs; [
      rofi-power-menu
    ];

    terminal = lib.getExe pkgs.foot;
  };
}
