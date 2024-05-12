let
  host = import ./host.nix;
in {
  networking = {
    hostName = host.name;
    search = [host.domain];

    networkmanager.enable = true;
    nftables.enable = true;
  };
}
