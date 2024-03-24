let
  host = import ./host.nix;
in {
  networking = {
    hostName = host.name;
    search = [host.domain];
    firewall.allowedTCPPorts = [22];

    networkmanager.enable = true;
    nftables.enable = true;

    extraHosts = ''
      ::1 ${host.fqdn}
      127.0.0.2 ${host.fqdn}
    '';
  };
}
