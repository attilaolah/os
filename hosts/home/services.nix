{
  services = {
    dbus.enable = true;

    openssh = {
      enable = true;
      startWhenNeeded = true;  # make it socket-activated
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    # Only used on the virtual console.
    xserver.xkb = {
      layout = "us";
      variant = "dvp";
      options = "caps:escape,compose:ralt,keypad:atm,kpdl:semi,numpad:shift3";
    };
  };
}
