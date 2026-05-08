# https://mynixos.com/home-manager/options/services.gpg-agent
{pkgs, ...}: {
  services.gpg-agent = {
    enable = true;
    # On MacOS, Secretive is used as the primary SSH agent.
    # However, GPG-agent is still enabled and can be manually selected, e.g. via host rules.
    enableSshSupport = true;
    defaultCacheTtl = 8 * 60 * 60; # 8h in secs
    pinentry.package = with pkgs; lib.mkForce pinentry-tty;
    sshKeys = [
      "2CCBD7C415983C9B20762124B39B41EC96B810DA" # workstation
      "41AAF08280AC45DD018D66EE8499FC8E211706D7" # laptop
    ];
  };
}
