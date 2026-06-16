{pkgs, ...}: {
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;
    tui.theme = "catppuccin";
    settings = {
      autoshare = false;
      autoupdate = false;
    };
  };
}
