{pkgs, ...}: {
  programs.rofi = {
    enable = true;

    plugins = with pkgs; [
      rofi-power-menu
    ];

    terminal = "${pkgs.foot}/bin/foot";
  };
}
