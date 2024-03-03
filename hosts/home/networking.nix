{
  networking = {
    hostName = "home";
    search = [ "dorn.haus" ];
    firewall.allowedTCPPorts = [ 22 8080 ];

    networkmanager.enable = true;
    nftables.enable = true;

    wireguard.interfaces = {
      dh8 = {
        ips = [
          "fd10:8::1:2/64"  # jh: fd10:8::1:1
          "10.8.1.2/16"     # jh: 10.8.1.1
        ];
        privateKeyFile = "/etc/wireguard/dh8.home.key";
        peers = [
          {
            publicKey = "dQNahUFr2rm4uRqPIE4ZwwGt9WXcoUtkVOmApM8AYU8=";
            allowedIPs = [
              "::/0"         # IPv6: all traffic
              "10.8.0.0/16"  # IPv4: 16-bit network only
            ];
            endpoint = "192.168.1.4:45340";
            persistentKeepalive = 24;
          }
        ];
      };
    };
  };
}
