let
  host = import ./host.nix;
in {
  networking = {
    hostName = host.name;
    search = [host.domain];
    firewall.allowedTCPPorts = [22 8080];

    networkmanager.enable = true;
    nftables.enable = true;

    # FQDN used to override public addresses. i.e. home.dorn.haus should
    # resolve to a pinholed IPv6 address, but internally it should still point
    # to ::1.
    extraHosts = ''
      ::1 ${host.fqdn}
      127.0.0.2 ${host.fqdn}

      10.0.0.1 modem
      10.10.10.10 dorn.haus
      192.168.0.1 wifi
    '';
  };
}
