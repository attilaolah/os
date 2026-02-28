let
  host = import ./host.nix;
in {
  networking = {
    hostName = host.name;
    search = [host.domain];
    firewall.allowedTCPPorts = [22 8080];
    nftables.enable = true;

    networkmanager = {
      enable = true;
      # Disallow the ISP's DNS config.
      dns = "systemd-resolved";
      connectionConfig = {
        "ipv4.ignore-auto-dns" = "yes";
        "ipv6.ignore-auto-dns" = "yes";
      };
    };
    # Google DNS with the hostname for certificate verification.
    nameservers = [
      "8.8.4.4#dns.google"
      "8.8.8.8#dns.google"
    ];

    # FQDN used to override public addresses. i.e. home.dorn.haus should
    # resolve to a pinholed IPv6 address, but internally it should still point
    # to ::1.
    extraHosts = ''
      ::1 ${host.fqdn}
      127.0.0.2 ${host.fqdn}

      192.168.0.1 router
      192.168.1.1 uplink
    '';
  };
}
