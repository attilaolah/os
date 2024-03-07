{
  services.loki = {
    enable = true;

    configuration = let
      dir = "/var/lib/loki";
    in {
      # We only bind to the loopback interface.
      # Should be changed if the server is exposed on the network.
      auth_enabled = false;

      server = {
        http_listen_address = "[::1]";
        http_listen_port = 3100; # the default
        grpc_listen_port = 0; # random
      };

      ingester = {
        lifecycler = {
          address = "::1";
          ring = {
            kvstore = {
              store = "inmemory";
            };
            replication_factor = 1;
          };
        };
      };

      compactor = {
        working_directory = dir;
        shared_store = "filesystem";
        compactor_ring = {
          kvstore = {
            store = "inmemory";
          };
        };
      };

      schema_config = {
        configs = [
          {
            from = "2024-01-01";
            store = "boltdb-shipper";
            object_store = "filesystem";
            schema = "v12";
            index = {
              prefix = "idx_";
              period = "1d";
            };
          }
        ];
      };

      storage_config = {
        boltdb_shipper = {
          active_index_directory = "${dir}/boltdb-shipper";
          cache_location = "${dir}/boltdb-shipper-cache";
          shared_store = "filesystem";
        };
        filesystem = {
          directory = "${dir}/chunks";
        };
      };
    };
  };
}
