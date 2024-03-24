{pkgs, ...}: {
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 60 * 60 * 2; # 2h in secs
    pinentryPackage = with pkgs; lib.mkForce pinentry-curses;
    sshKeys = ["2CCBD7C415983C9B20762124B39B41EC96B810DA"];
  };
}
