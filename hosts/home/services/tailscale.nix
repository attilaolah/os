{
  services.tailscale = {
    enable = true;
    extraUpFlags = "--accept-routes";
  };
}
