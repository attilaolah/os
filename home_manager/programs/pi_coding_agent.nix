{pkgs, ...}: {
  programs.pi-coding-agent = {
    enable = true;
    package = pkgs.pi-coding-agent;
  };
}
