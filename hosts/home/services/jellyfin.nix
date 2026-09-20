{
  lib,
  pkgs,
  ...
}: let
  user = "media";
  group = user;
  socket = "/run/jellyfin/jellyfin.sock";
  port = toString 8096;
in {
  services.jellyfin = {
    inherit group;
    enable = true;
  };

  users = {
    users.${user} = {
      inherit group;
      isSystemUser = true;
    };
    groups.${group} = {};
  };

  systemd = {
    # Keep media separate from Jellyfin's state, which remains in its default locations under /var/lib and /var/cache.
    tmpfiles.settings.media = {
      "/srv/media".d = {
        inherit user group;
        mode = "0750";
      };
    };

    # Jellyfin has no systemd socket-activation support. Have it listen on a private Unix socket instead.
    services.jellyfin = {
      wantedBy = lib.mkForce [];
      unitConfig.StopWhenUnneeded = true;
      preStart = lib.mkBefore ''
        install -Dm600 ${pkgs.writeText "jellyfin-network.xml" ''
          <?xml version="1.0" encoding="utf-8"?>
          <NetworkConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
            <EnableIPv4>false</EnableIPv4>
            <EnableIPv6>false</EnableIPv6>
            <PublicHttpPort>${port}</PublicHttpPort>
          </NetworkConfiguration>
        ''} /var/lib/jellyfin/config/network.xml
      '';
      serviceConfig = {
        RuntimeDirectory = "jellyfin";
        RuntimeDirectoryMode = "0750";
        Environment = [
          "JELLYFIN_kestrel__socket=true"
          "JELLYFIN_kestrel__socketPath=${socket}"
        ];
      };
    };

    # Exposes the private Jellyfin listener on TCP port 8096.
    sockets.jellyfin = {
      description = "Jellyfin Media Server socket";
      wantedBy = ["sockets.target"];
      listenStreams = ["[::]:${port}" "0.0.0.0:${port}"];
      socketConfig = {
        Accept = true;
        BindIPv6Only = "ipv6-only";
      };
    };

    services."jellyfin@" = {
      description = "Jellyfin socket proxy for connection %i";
      requires = ["jellyfin.service"];
      after = ["jellyfin.service"];
      serviceConfig = {
        ExecStartPre = lib.getExe (pkgs.writeShellApplication {
          name = "jellyfin-socket-wait";
          runtimeInputs = with pkgs; [coreutils];
          text = ''
            for _ in {1..600}; do
              [[ -S "${socket}" ]] && exit 0
              sleep 0.1
            done

            exit 1
          '';
        });
        ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=20min ${socket}";
        StandardInput = "socket";
      };
    };
  };
}
