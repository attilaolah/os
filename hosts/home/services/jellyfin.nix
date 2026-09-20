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

    # Jellyfin has no systemd socket-activation support. Have it listen on a private Unix socket instead.
    services.jellyfin = {
      wantedBy = lib.mkForce [];
      unitConfig.StopWhenUnneeded = true;
      serviceConfig = {
        RuntimeDirectory = "jellyfin";
        RuntimeDirectoryMode = "0750";
        Environment = [
          "JELLYFIN_kestrel__socket=true"
          "JELLYFIN_kestrel__socketPath=/run/jellyfin/jellyfin.sock"
        ];
      };
    };

    # Exposes Jellyfin on TCP port 8096.
    sockets.jellyfin = {
      description = "Jellyfin Media Server socket";
      wantedBy = ["sockets.target"];
      listenStreams = ["8096"];
      socketConfig.Accept = true;
    };

    services."jellyfin@" = {
      description = "Jellyfin socket proxy for connection %i";
      requires = ["jellyfin.service"];
      after = ["jellyfin.service"];
      serviceConfig = {
        ExecStartPre = "${pkgs.bash}/bin/bash -c 'for _ in {1..600}; do [[ -S /run/jellyfin/jellyfin.sock ]] && exit 0; sleep 0.1; done; exit 1'";
        ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=20min /run/jellyfin/jellyfin.sock";
        StandardInput = "socket";
      };
    };
  };
}
