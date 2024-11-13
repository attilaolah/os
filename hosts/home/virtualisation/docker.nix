{
  virtualisation.docker = {
    enable = true;

    enableOnBoot = false; # use socket activation

    daemon.settings = {
      ipv6 = true;
      fixed-cidr-v6 = "fd10:6::/64";
      features.containerd-snapshotter = true;
    };
  };
}
