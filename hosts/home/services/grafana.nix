{config, ...}: {
  services.grafana = {
    enable = true;

    settings.server = {
      # NOTE: Square brackets required for now:
      # https://github.com/grafana/grafana/issues/81870
      http_addr = "[::1]";

      # Serve Grafana through a reverse proxy.
      root_url = "https://${config.networking.hostName}.${builtins.head config.networking.search}/grafana";
      serve_from_sub_path = true;
    };
  };
}
