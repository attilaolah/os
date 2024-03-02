{
  networking = {
    hostName = "home";
    search = [ "dorn.haus" ];
    firewall.allowedTCPPorts = [ 22 8080 ];

    networkmanager.enable = true;
    nftables.enable = true;
  };
}
