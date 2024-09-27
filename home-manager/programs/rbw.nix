{
  pkgs,
  email,
  ...
}: {
  programs.rbw = {
    enable = true;
    settings = {
      # TODO: DRY!
      email = email;
      pinentry = pkgs.pinentry-tty;
    };
  };
}
