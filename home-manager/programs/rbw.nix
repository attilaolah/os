{
  config,
  pkgs,
  ...
}: {
  programs.rbw = {
    enable = true;
    settings = {
      pinentry = pkgs.pinentry-tty;
      email = config.sops.placeholder."contact/email";
    };
  };
}
