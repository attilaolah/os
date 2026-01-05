{
  pkgs,
  user,
  ...
}: {
  programs.rbw = {
    enable = true;
    settings = {
      inherit (user) email;
      pinentry = pkgs.pinentry-tty;
    };
  };
}
