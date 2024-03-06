{
  services.openssh = {
    enable = true;
    startWhenNeeded = true; # make it socket-activated
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
