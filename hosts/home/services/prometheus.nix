{config, ...}: {
  services.prometheus = {
    enable = true;

    listenAddress = "[::1]";

    exporters = {
      node = {
        enable = true;

        listenAddress = "[::1]";
        enabledCollectors = ["systemd"];
      };
    };

    scrapeConfigs = [
      {
        job_name = "node-exporter";
        static_configs = [
          {
            targets = with config.services.prometheus.exporters; [
              "${node.listenAddress}:${toString node.port}"
            ];
          }
        ];
      }
    ];
  };
}
