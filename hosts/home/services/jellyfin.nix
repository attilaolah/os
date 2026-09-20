{
  lib,
  pkgs,
  ...
}: let
  user = "media";
  group = user;
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

    # Jellyfin has no systemd socket-activation support. Have it listen only on loopback instead.
    services.jellyfin = {
      wantedBy = lib.mkForce [];
      unitConfig.StopWhenUnneeded = true;
      preStart = lib.mkBefore ''
        install -Dm600 ${pkgs.writeText "jellyfin-network.xml" ''
          <?xml version="1.0" encoding="utf-8"?>
          <NetworkConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
            <LocalNetworkAddresses>
              <string>127.0.0.1</string>
            </LocalNetworkAddresses>
            <InternalHttpPort>8097</InternalHttpPort>
            <PublicHttpPort>8096</PublicHttpPort>
          </NetworkConfiguration>
        ''} /var/lib/jellyfin/config/network.xml
      '';
    };

    # Exposes the loopback-only Jellyfin listener on TCP port 8096.
    sockets.jellyfin = {
      description = "Jellyfin Media Server socket";
      wantedBy = ["sockets.target"];
      listenStreams = ["[::]:8096" "0.0.0.0:8096"];
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
          runtimeInputs = with pkgs; [netcat-openbsd];
          text = ''
            for _ in {1..600}; do
              nc -z 127.0.0.1 8097 && exit 0
              sleep 0.1
            done

            exit 1
          '';
        });
        ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=20min 127.0.0.1:8097";
        StandardInput = "socket";
      };
    };
  };
}
