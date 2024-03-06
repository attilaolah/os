{
  config,
  lib,
  ...
}: let
  host = import ../host.nix;
  grafana = config.services.grafana.settings.server;
  grafanaLoc = with builtins; rec {
    parts = lib.strings.splitString "/" grafana.root_url;
    last = elemAt parts ((length parts) - 1);
  }.last;
in {
  services.nginx = {
    enable = true;

    virtualHosts.${host.fqdn} = {
      locations."/${grafanaLoc}" = {
        proxyPass = with grafana; "http://${http_addr}:${toString http_port}";
        proxyWebsockets = true;
      };
    };
  };
}
