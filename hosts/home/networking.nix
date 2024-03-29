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
    # resolve to a apinholed IPv6 address, but internally it should still point
    # to ::1.
    extraHosts = ''
      ::1 ${host.fqdn}
      127.0.0.2 ${host.fqdn}

      192.168.0.1 wifi
      192.168.1.1 modem

      192.168.4.1 jh jh.${host.domain}
    '';

    wireguard.interfaces = {
      dh8 = {
        ips = ["fd10:4::2/64"]; # jh: fd10:4::1
        privateKeyFile = "/etc/wireguard/dh8.home.key";
        peers = [
          {
            publicKey = "dQNahUFr2rm4uRqPIE4ZwwGt9WXcoUtkVOmApM8AYU8=";
            allowedIPs = ["::/0"]; # IPv6: all traffic
            endpoint = "192.168.4.1:45340";
            persistentKeepalive = 24;
          }
        ];
      };
    };
  };
}
