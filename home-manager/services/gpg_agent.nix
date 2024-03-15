{pkgs, ...}: {
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 60 * 60 * 2; # 2h in secs
    pinentryPackage = pkgs.lib.mkForce pkgs.pinentry-curses;
  };
}
