let
  settings = {
    ipv6 = true;
    fixed-cidr-v6 = fd10:6::/64;
  };
in {
  virtualisation.docker = {
    enable = true;

    # Use socket activation.
    # Since rootless access is enabled, it is unlikely that we will need to
    # start this service, but it is still installed as a fallback option.
    enableOnBoot = false; # use socket activation

    daemon = {inherit settings;};

    rootless = {
      enable = true;

      # Set the socket variable for users.
      # This way the docker commands will use the per-user service by default.
      # It needs to be started by running `systemctl --user start docker`.
      setSocketVariable = true;

      daemon = {inherit settings;};
    };
  };
}
