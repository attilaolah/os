{pkgs, ...}: {
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 60 * 60 * 8; # 8h in secs
    pinentryPackage = with pkgs; lib.mkForce pinentry-tty;
    sshKeys = ["2CCBD7C415983C9B20762124B39B41EC96B810DA"];
  };
}
