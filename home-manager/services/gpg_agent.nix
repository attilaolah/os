{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 7200; # 2h
    pinentryFlavor = "curses";
  };
}
