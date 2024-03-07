{config, ...}: let
  host = import ../host.nix;
  loki = config.services.loki;
in {
  services.promtail = {
    enable = true;

    configuration = {
      server = {
        http_listen_address = "[::1]";
        http_listen_port = 9080; # default = 80
        grpc_listen_port = 0; # random
      };

      clients = [
        {
          url = with loki.configuration.server; "http://${http_listen_address}:${toString http_listen_port}/loki/api/v1/push";
        }
      ];

      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = host.name;
            };
          };
          relabel_configs = [
            {
              source_labels = ["__journal__systemd_unit"];
              target_label = "unit";
            }
          ];
        }
      ];
    };
  };
}
