{pkgs, ...}: {
  programs.antigravity-cli = {
    enable = true;
    enableMcpIntegration = true;
    package = pkgs.antigravity-cli;
  };
}
